# Custom 19-Bit Single-Cycle CPU

![Verilog](https://img.shields.io/badge/Language-Verilog-blue.svg)

This project is a complete Verilog implementation of a custom 19-bit, single-cycle processor. The design was built from the ground up to execute a specific set of 21 instructions, including arithmetic, logical, memory access, and control flow operations. The project is fully self-contained in a single file and includes a testbench for verification.

---
## 📜 Core Specifications

* **Architecture**: Single-Cycle
* **Data/Instruction Width**: 19-bit
* **Registers**: 8 General-Purpose Registers (`r0`-`r7`), with `r0` hardwired to zero.
* **Instruction Set**: Custom ISA with 21 instructions (Arithmetic, Logical, Memory, Control Flow, Specialized)
* **Memory**: Unified instruction and data memory space.

---
## 🏗️ Architecture

A **single-cycle architecture** was chosen for this project due to its simplicity and clarity. Every instruction is executed in exactly one clock cycle, which makes the control logic straightforward and the data flow easy to trace and debug. This approach is perfectly suited to the project's goal of correctly implementing a custom instruction set.

The design follows a classic datapath structure, connecting the core components as shown below.



---
## 📦 Modules

The processor is built from several distinct hardware blocks, which are all instantiated and wired together in the main `cpu_top` module.

* **`cpu_top`**: The top-level module that contains the entire processor datapath and connects all other components.
* **`control_unit`**: The "brain" of the CPU. It decodes the instruction's opcode and generates the control signals that command the rest of the datapath.
* **`alu`**: The "calculator" of the CPU. It performs all arithmetic (add, sub, mul, div) and logical (and, or, xor) operations.
* **`register_file`**: A small, high-speed set of 8 registers used as a "scratchpad" to hold data that is being actively processed.
* **`memory`**: The main storage for the program's instructions and data. It includes a programming port to allow a testbench to load the program.
* **`specialized_units`**: Placeholder modules (`fft_unit`, `encrypt_unit`, `decrypt_unit`) to demonstrate that the CPU datapath is ready to support hardware accelerators.
* **`testbench`**: A module to simulate and verify the CPU. It loads a test program, provides clock and reset signals, and checks the final output for correctness.

---
## 📝 Instruction Set Overview

The 19-bit instruction width allows for several formats to accommodate different types of operations. The 5-bit opcode is sufficient for the 21 specified instructions.

| Instruction | Example             | Description                                          |
| :---------- | :------------------ | :--------------------------------------------------- |
| `ADD`       | `ADD r3, r1, r2`    | Adds values in `r1` and `r2`, stores the result in `r3`. |
| `LD`        | `LD r1, 100`        | Loads a value from memory address 100 into `r1`.     |
| `ST`        | `ST 102, r3`        | Stores the value from `r3` into memory address 102.  |
| `BEQ`       | `BEQ r1, r2, offset`| Branches to a new address if `r1` equals `r2`.         |
| `CALL`      | `CALL 10`           | Jumps to a subroutine, saving the return address on the stack. |
| `JMP`       | `JMP 4`             | Unconditionally jumps to a new address.              |

---
## ⚙️ How to Simulate

To run this project, you will need a Verilog simulator (e.g., Xilinx Vivado, ModelSim, Icarus Verilog).

1.  **Save the Code**: Save the entire Verilog project code into a single file named `single_cycle_cpu.v`.
2.  **Set Up Simulation**: Add the file to your simulator's project and set the `testbench` module as the top level for the simulation.
3.  **Run Simulation**: Compile and run the simulation.

The testbench will automatically perform the following steps:
* Generate a clock and reset signal.
* Load a test program into the CPU's instruction memory.
* Check the final contents of the data memory to verify the program's output.
* Print a `SUCCESS` or `FAILURE` message to the console.
* Generate a waveform file named **`cpu_waveform.vcd`** for detailed, cycle-by-cycle analysis in a waveform viewer like GTKWave.

---
## 🔬 In-Depth Verification

Beyond running the main test program, the design's modularity allows you to test each component individually.

### Interactive "Forcing" in the Simulator
As we need, we can test submodules like the ALU directly within the main simulation. This is a great way to do quick "what-if" checks without writing a new testbench.

1.  **Run the main simulation** in your tool (like Vivado).
2.  In the **Scope** window, navigate down into the CPU instance (`uut`) and find the module you want to test (e.g., `uut.alu_unit`).
3.  Add that module's input and output ports to the **waveform viewer** (e.g., `A`, `B`, `ALUOp`, and `Result`).
4.  Right-click on an input signal in the waveform and use the **"Force Constant"** feature to manually set its value.

**For example, to test the ALU's subtract function:** you can force input `A` to `100`, input `B` to `30`, and the `ALUOp` signal to `5'b00001` (the code for `SUB`). You should see the `Result` signal immediately update to `70`, verifying that the subtraction logic works.

### Dedicated Unit Testbenches
For more thorough testing, the standard industry practice is to write a small, separate testbench for each module. This is called **unit testing**. For example, you could create a `tb_alu.v` that only instantiates the ALU and contains a script to automatically test hundreds of different input combinations and operations, checking each result. This ensures every component is flawless before it's integrated into the full CPU.
