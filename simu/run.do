vlib work
vlog  systolic_array.sv systolic_array_tb.sv
transcript file file.log
vsim -voptargs=+acc work.systolic_array_tb
add wave *
add wave -radix unsigned -position insertpoint  \
sim:/systolic_array_tb/dut/matrix_a_in \
sim:/systolic_array_tb/dut/matrix_b_in \
sim:/systolic_array_tb/dut/matrix_a_delayed \
sim:/systolic_array_tb/dut/matrix_b_delayed \
sim:/systolic_array_tb/dut/a_interconnects \
sim:/systolic_array_tb/dut/b_interconnects \
{sim:/systolic_array_tb/dut/GEN_PE_R[0]/GEN_PE_C[0]/pe_inst/sum} \
{sim:/systolic_array_tb/dut/GEN_PE_R[0]/GEN_PE_C[0]/pe_inst/c_out} \
{sim:/systolic_array_tb/dut/GEN_PE_R[0]/GEN_PE_C[0]/pe_inst/valid_out} \
{sim:/systolic_array_tb/dut/GEN_PE_R[0]/GEN_PE_C[1]/pe_inst/sum} \
{sim:/systolic_array_tb/dut/GEN_PE_R[0]/GEN_PE_C[1]/pe_inst/c_out} \
{sim:/systolic_array_tb/dut/GEN_PE_R[0]/GEN_PE_C[1]/pe_inst/valid_out} \
{sim:/systolic_array_tb/dut/GEN_PE_R[0]/GEN_PE_C[2]/pe_inst/sum} \
{sim:/systolic_array_tb/dut/GEN_PE_R[0]/GEN_PE_C[2]/pe_inst/c_out}\
{sim:/systolic_array_tb/dut/GEN_PE_R[0]/GEN_PE_C[2]/pe_inst/valid_out} \
sim:/systolic_array_tb/dut/row_c_out \
sim:/systolic_array_tb/dut/matrix_c_out
run -all