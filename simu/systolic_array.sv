module systolic_array #(
    parameter N_SIZE = 5 ,
    parameter DATAWIDTH = 16
) (
    input logic clk,rst_n,valid_in, // Asynchronous Active low 
    input wire signed [DATAWIDTH-1:0] matrix_a_in [0:N_SIZE-1], //Data Array  [COLOMN][DATA]
    input wire signed [DATAWIDTH-1:0] matrix_b_in [0:N_SIZE-1], //Data Array  [COLOMN][DATA]
    output logic valid_out,
    output logic signed [2*DATAWIDTH-1:0]matrix_c_out[0:N_SIZE-1]
     // Data Array [Each block in last row OUTPUT][DATA]
);

//Local Variables:
logic [DATAWIDTH-1:0] matrix_a_delayed [0:N_SIZE-1][0:N_SIZE-1]; // [ROW][STAGE][DATA]
logic [DATAWIDTH-1:0] matrix_b_delayed [0:N_SIZE-1][0:N_SIZE-1]; // [COLOMN][STAGE][DATA]

logic [DATAWIDTH-1:0] a_interconnects [0:N_SIZE-1][0:N_SIZE-1]; // a_in connections [ROW][COLOMN][DATA]
logic [DATAWIDTH-1:0] b_interconnects [0:N_SIZE-1][0:N_SIZE-1]; // b_in connections [COLOMN][ROW][DATA]

logic valid_out_array [N_SIZE-1:0][N_SIZE-1:0];

logic signed [2*DATAWIDTH-1:0] row_c_out [0:N_SIZE-1][0:N_SIZE-1];


//Generates iterators:  
genvar row_h, col_h;
genvar row_v, col_v;
//Instantiating Horizontal Flip-Flops:
generate
    for (row_h = 0; row_h < N_SIZE; row_h++) begin : GEN_ROW_H
        for (col_h = 0; col_h <= row_h; col_h++) begin : GEN_COL_H_A
            if (col_h == 0) begin
                assign matrix_a_delayed[row_h][col_h] = matrix_a_in[row_h];
            end else begin
                D_ff #(.DATAWIDTH(DATAWIDTH)) dff_a (
                    .clk(clk),
                    .rst_n(rst_n),
                    .d_in(matrix_a_delayed[row_h][col_h-1]),
                    .d_out(matrix_a_delayed[row_h][col_h])
                );
            end
        end
    end
endgenerate

//Instantiating Vertical Flip-Flops:
generate
    for (col_v = 0; col_v<N_SIZE ; col_v++ ) begin : GEN_COL_v
        for (row_v =0; row_v<=col_v ;row_v++ ) begin : GEN_ROW_V_B
            if (row_v == 0) begin
                assign matrix_b_delayed[col_v][row_v] = matrix_b_in[col_v];
            end else begin
                D_ff #(.DATAWIDTH(DATAWIDTH)) dff_b (
                    .clk(clk),
                    .rst_n(rst_n),
                    .d_in(matrix_b_delayed[col_v][row_v-1]),
                    .d_out(matrix_b_delayed[col_v][row_v]));
            end
        end
    end
endgenerate

//Connecting interconnected to delayed matrix:
generate
    for (genvar row = 0 ; row<N_SIZE ;row++ ) begin :GEN_ROW_ASSIGN
        assign a_interconnects[row][0] = matrix_a_delayed[row][row];
    end
    for (genvar col = 0 ; col<N_SIZE ;col++ ) begin :GEN_COL_ASSIGN
        assign b_interconnects[col][0] = matrix_b_delayed[col][col];
    end
endgenerate

//PE Instantiation:
genvar row_PE, col_PE;
generate
    for (row_PE = 0; row_PE<N_SIZE ; row_PE++ ) begin :GEN_PE_R
        for (col_PE = 0; col_PE<N_SIZE ; col_PE++ ) begin :GEN_PE_C
                PE #(
                .N_SIZE(N_SIZE),
                .DATAWIDTH(DATAWIDTH),
                .x_id(row_PE),
                .y_id(col_PE)
                ) pe_inst (
                .clk(clk),
                .rst_n(rst_n),
                .valid_in(valid_in),
                .a_in(a_interconnects[row_PE][col_PE]),
                .b_in(b_interconnects[col_PE][row_PE]),
                .valid_out(valid_out_array[row_PE][col_PE]),
                .a_out_right(a_interconnects[row_PE][col_PE+1]),
                .b_out_down(b_interconnects[col_PE][row_PE+1]),
                .c_out(row_c_out[row_PE][col_PE]));
       end
    end
endgenerate
// valid_out logic: high when any row's last PE is valid
always_comb begin
    valid_out = 0;
    for (int row = 0; row < N_SIZE; row++) begin
        if (valid_out_array[row][N_SIZE-1]) begin
            valid_out = 1;
        end
    end
end

//OUTPUT MUX
always_comb begin
    matrix_c_out = '{default:0};
    for (int row = 0; row < N_SIZE; row++) begin
        if (valid_out_array[row][N_SIZE-1]) begin
            for (int col = 0; col < N_SIZE; col++) begin
                matrix_c_out[col] = row_c_out[row][col];
            end
        end
    end
end


endmodule




module PE #(
    parameter N_SIZE = 5,
    parameter DATAWIDTH = 16,
    parameter x_id = 0 ,
    parameter y_id = 0 
) (
    input logic clk,rst_n,valid_in,
    input logic signed [DATAWIDTH-1:0] a_in,b_in,
    output logic valid_out,
    output logic signed [(DATAWIDTH)-1:0]b_out_down,
    output logic signed [(DATAWIDTH)-1:0]a_out_right,
    output logic signed [(2*DATAWIDTH)-1:0]c_out
);

logic [N_SIZE:0] internal_counter;
logic [(2*DATAWIDTH)-1:0] sum;
logic valid_in_flag_holder;
    always @(posedge clk , negedge rst_n)begin
       if (!rst_n) begin
            internal_counter <= 0;
            sum <= 0;
            valid_in_flag_holder <=0;
            c_out<=0;
       end 
       else begin
        valid_out<=0;
        if (valid_in || valid_in_flag_holder) begin
            valid_in_flag_holder<=1;
            if (internal_counter < N_SIZE + x_id + y_id) begin
                internal_counter <= internal_counter + 1; 
                if (internal_counter >= x_id +y_id) begin
                    if (internal_counter == N_SIZE + x_id + y_id - 1) begin
                        valid_out <= 1;
                        valid_in_flag_holder <= 0;
                        internal_counter <= 0;
                        c_out <= sum + (a_in*b_in);
                        sum <= 0;
                    end
                    else begin
                        sum <= sum + (a_in*b_in);
                    end
                    a_out_right <= a_in;
                    b_out_down <= b_in;
                end
            end
            else begin
                
            end
        end   
       end 
    end
endmodule

module D_ff #(
    parameter DATAWIDTH = 16 
) (
    input logic clk,rst_n,
    input logic [DATAWIDTH-1:0] d_in,
    output logic [DATAWIDTH-1:0] d_out
);

always @(posedge clk , negedge rst_n) begin
    if(!rst_n) d_out <= 0;
    else d_out <= d_in;
end
    
endmodule
