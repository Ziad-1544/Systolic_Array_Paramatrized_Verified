# Systolic Array Project

## Overview

This project implements a parameterized Systolic Array in SystemVerilog for matrix multiplication. The design includes a configurable array size (`N_SIZE`) and data width (`DATAWIDTH`). The array is built from Processing Elements (PEs) that perform multiply-accumulate operations in a pipelined fashion.

## File Structure

- `rtl/systolic_array.sv`  
  Main systolic array module, PE module, and D flip-flop module.

- `simu/systolic_array_tb.sv`  
  Testbench for simulation, including clock generation, reset, and input stimulus.

## Modules

### systolic_array

- **Parameters:**  
  - `N_SIZE`: Size of the array (number of rows/columns).
  - `DATAWIDTH`: Bit width of input data.

- **Ports:**  
  - `clk`, `rst_n`, `valid_in`: Clock, active-low reset, and input valid signal.
  - `matrix_a_in`, `matrix_b_in`: Input vectors for matrix A and B.
  - `valid_out`: Output valid signal.
  - `matrix_c_out`: Output vector for result.

- **Description:**  
  The systolic array instantiates a grid of PEs. Data is delayed and routed through flip-flops to each PE. The output is multiplexed based on which row's valid signal is asserted.

### PE

- **Parameters:**  
  - `N_SIZE`, `DATAWIDTH`, `x_id`, `y_id`: Array size, data width, and PE coordinates.

- **Ports:**  
  - `clk`, `rst_n`, `valid_in`: Clock, reset, and input valid.
  - `a_in`, `b_in`: Inputs for the PE.
  - `valid_out`: Output valid signal.
  - `a_out_right`, `b_out_down`: Outputs to neighboring PEs.
  - `c_out`: Computed output.

- **Description:**  
  Each PE performs multiply-accumulate operations and passes data to its neighbors. The output is asserted when computation is complete.

### D_ff

- **Parameters:**  
  - `DATAWIDTH`: Bit width.

- **Ports:**  
  - `clk`, `rst_n`, `d_in`, `d_out`: Standard D flip-flop ports.

## Simulation

- The testbench applies input vectors to the systolic array and monitors the output.
- Example test cases for 2x2 and 3x3 arrays are included.
- The output is checked against expected matrix multiplication results.

## How to Run

1. Open the project in your preferred SystemVerilog simulator.
2. Compile all files in the `rtl` and `simu` directories.
3. Run the simulation using `systolic_array_tb`.
4. Observe the output in the waveform viewer or console.

## Notes

- Ensure `N_SIZE` and `DATAWIDTH` are set appropriately for your test cases.
- The output order depends on the PE grid mapping; see comments in the code for details.
- For larger matrices, adjust the input vectors and simulation cycles accordingly.
