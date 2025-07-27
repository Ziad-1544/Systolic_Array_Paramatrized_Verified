module systolic_array_tb;
    localparam N_SIZE = 5;
    localparam DATAWIDTH = 16;

    logic clk, rst_n, valid_in;
    logic signed [DATAWIDTH-1:0] matrix_a_in [N_SIZE-1:0];
    logic signed [DATAWIDTH-1:0] matrix_b_in [N_SIZE-1:0];
    logic valid_out;
    logic signed [2*DATAWIDTH-1:0] matrix_c_out [N_SIZE-1:0];

    // Instantiate DUT
    systolic_array #(
        .N_SIZE(N_SIZE),
        .DATAWIDTH(DATAWIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .matrix_a_in(matrix_a_in),
        .matrix_b_in(matrix_b_in),
        .valid_out(valid_out),
        .matrix_c_out(matrix_c_out)
    );

    // Clock generation
    initial begin
        clk=0;
        forever begin
            #1 clk=~clk;
        end
    end

    // Test vectors
    initial begin
        rst_n = 0;
        valid_in = 0;
        matrix_a_in = '{default:0};
        matrix_b_in = '{default:0};
        repeat(1) @(negedge clk);
        rst_n = 1;

        // // Test Case 1 3 * 3
        // matrix_a_in = '{1,2,3};
        // matrix_b_in = '{3,4,5};
        // valid_in = 1;
        // repeat(1) @(negedge clk);
        // matrix_a_in = '{4,5,6};
        // matrix_b_in = '{6,7,8};
        // repeat(1) @(negedge clk);
        
        // matrix_a_in = '{7,8,9};
        // matrix_b_in = '{9,10,11};
        // repeat(1) @(negedge clk);
        // valid_in = 0;
               
        // repeat(10) @(negedge clk);

        //

        // Test Case 1 5*5
        matrix_a_in = '{1, 2, 3, 4, 5};
        matrix_b_in = '{25, 24, 23, 22, 21};
        valid_in = 1;
        repeat(1) @(negedge clk);

        matrix_a_in = '{6, 7, 8, 9, 10};
        matrix_b_in = '{20, 19, 18, 17, 16};
        repeat(1) @(negedge clk);

        matrix_a_in = '{11, 12, 13, 14, 15};
        matrix_b_in = '{15, 14, 13, 12, 11};
        repeat(1) @(negedge clk);

        matrix_a_in = '{16, 17, 18, 19, 20};
        matrix_b_in = '{10, 9, 8, 7, 6};
        repeat(1) @(negedge clk);

        matrix_a_in = '{21, 22, 23, 24, 25};
        matrix_b_in = '{5, 4, 3, 2, 1};
        repeat(1) @(negedge clk);

        valid_in = 0;
        repeat(13) @(negedge clk);
        $display("Test 1 should be done");
        $stop;
        //=================================================================
        // Test Case 2 5*5
        matrix_a_in = '{5, 4, 3, 2, 1};
        matrix_b_in = '{1, 1, 1, 1, 1};
        valid_in = 1;
        repeat(1) @(negedge clk);

        matrix_a_in = '{10, 9, 8, 7, 6};
        matrix_b_in = '{2, 2, 2, 2, 2};
        repeat(1) @(negedge clk);

        matrix_a_in = '{15, 14, 13, 12, 11};
        matrix_b_in = '{3, 3, 3, 3, 3};
        repeat(1) @(negedge clk);

        matrix_a_in = '{20, 19, 18, 17, 16};
        matrix_b_in = '{4, 4, 4, 4, 4};
        repeat(1) @(negedge clk);

        matrix_a_in = '{25, 24, 23, 22, 21};
        matrix_b_in = '{5, 5, 5, 5, 5};
        repeat(1) @(negedge clk);

        valid_in = 0;
        repeat(13) @(negedge clk);
        $display("Test 2 should be done");
        $stop;
        //===============================================================
        // Test Case 3 5*5
        matrix_a_in = '{1, 3, 5, 7, 9};
        matrix_b_in = '{5, 4, 3, 2, 1};
        valid_in = 1;
        repeat(1) @(negedge clk);

        matrix_a_in = '{2, 4, 6, 8, 10};
        matrix_b_in = '{10, 9, 8, 7, 6};
        repeat(1) @(negedge clk);

        matrix_a_in = '{11, 13, 15, 17, 19};
        matrix_b_in = '{15, 14, 13, 12, 11};
        repeat(1) @(negedge clk);

        matrix_a_in = '{12, 14, 16, 18, 20};
        matrix_b_in = '{20, 19, 18, 17, 16};
        repeat(1) @(negedge clk);

        matrix_a_in = '{21, 22, 23, 24, 25};
        matrix_b_in = '{25, 24, 23, 22, 21};
        repeat(1) @(negedge clk);

        valid_in = 0;
        repeat(13) @(negedge clk);
        $display("Test 3 should be done");
        $stop;
        //===============================================================
        // Test Case 4 5*5
        matrix_a_in = '{1, 0, 1, 0, 1};
        matrix_b_in = '{1, 2, 3, 4, 5};
        valid_in = 1;
        repeat(1) @(negedge clk);

        matrix_a_in = '{0, 1, 0, 1, 0};
        matrix_b_in = '{5, 4, 3, 2, 1};
        repeat(1) @(negedge clk);

        matrix_a_in = '{1, 1, 1, 1, 1};
        matrix_b_in = '{1, 2, 3, 4, 5};
        repeat(1) @(negedge clk);

        matrix_a_in = '{2, 2, 2, 2, 2};
        matrix_b_in = '{5, 4, 3, 2, 1};
        repeat(1) @(negedge clk);

        matrix_a_in = '{3, 3, 3, 3, 3};
        matrix_b_in = '{1, 2, 3, 4, 5};
        repeat(1) @(negedge clk);

        valid_in = 0;
        repeat(13) @(negedge clk);
        $display("Test 4 should be done");
        $stop;
        //===============================================================
        // Test Case 5 5*5
        matrix_a_in = '{1, 1, 1, 1, 1};
        matrix_b_in = '{1, 2, 3, 4, 5};
        valid_in = 1;
        repeat(1) @(negedge clk);

        matrix_a_in = '{2, 2, 2, 2, 2};
        matrix_b_in = '{6, 7, 8, 9, 10};
        repeat(1) @(negedge clk);

        matrix_a_in = '{3, 3, 3, 3, 3};
        matrix_b_in = '{11, 12, 13, 14, 15};
        repeat(1) @(negedge clk);

        matrix_a_in = '{4, 4, 4, 4, 4};
        matrix_b_in = '{16, 17, 18, 19, 20};
        repeat(1) @(negedge clk);

        matrix_a_in = '{5, 5, 5, 5, 5};
        matrix_b_in = '{21, 22, 23, 24, 25};
        repeat(1) @(negedge clk);

        valid_in = 0;
        repeat(13) @(negedge clk);
        $display("Test 5 should be done");
        $stop;
        end
        

endmodule
