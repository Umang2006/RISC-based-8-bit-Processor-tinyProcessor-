# 8-bit RISC-based Processor in Verilog

This repository contains the source code, testbenches, and documentation for a custom 8-bit RISC processor designed and implemented in Verilog HDL. The project was developed as part of a digital logic design course, demonstrating a comprehensive understanding of computer architecture, digital design, and hardware verification principles.

## Key Features

- **Custom 8-bit RISC Architecture:** A simple yet powerful instruction set designed for efficiency.
- **Modular Design:** The processor is composed of distinct modules for the ALU, Shifter, Register File, and Control Unit, promoting reusability and clarity.
- **Comprehensive Instruction Set (ISA):** Supports a variety of operations:
  - Arithmetic: ADD, SUB, MUL, INC, DEC
  - Logical: AND, XOR, CMP
  - Shift/Rotate: LSL, LSR, ASR, CIL, CIR
  - Data Transfer: MOV (register to accumulator and vice-versa)
  - Control Flow: BC (Branch if Carry/Borrow), HLT
- **Hardware Verified:** The design was thoroughly simulated in Vivado and synthesized for a Xilinx FPGA to ensure functional correctness and hardware viability.

## Repository Structure

<img width="977" height="355" alt="image" src="https://github.com/user-attachments/assets/4503ab93-6ee4-49de-82bb-9103f1414829" />



## How to Run the Simulation

### Prerequisites
Ensure you have [Xilinx Vivado](https://www.xilinx.com/products/design-tools/vivado.html) installed.

### Set up Project
- Create a new project in Vivado.
- Add all the Verilog files from the `src/` directory as design sources.
- Add the `processor_tb.v` file from the `sim/` directory as a simulation source.

### Run Simulation
- Set `processor_tb` as the top simulation module.
- Run the behavioral simulation. The console output and waveforms will demonstrate the processor executing a series of test instructions.

## Simulation Results

The processor's functionality was verified against a comprehensive testbench that covers all instructions. The simulation waveforms and detailed execution logs from the testbench confirm the correct operation of the datapath and control logic.
