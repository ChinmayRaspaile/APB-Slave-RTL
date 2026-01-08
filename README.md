# APB Slave RTL and SystemVerilog Verification

**Vivado 2025.1 Compatible**

---

## 1. Project Overview

This project implements a **behavioral APB3-compliant slave** using SystemVerilog and verifies it using a **self-checking SystemVerilog testbench** in Vivado 2025.

The purpose of the project is to demonstrate:

* Correct APB protocol behavior (setup and access phases)
* Clean, synthesizable behavioral RTL coding style
* Practical SystemVerilog verification without UVM
* Waveform-based validation using Vivado XSIM

This project is intended for learning, academic labs, and entry-level VLSI verification portfolios.

---

## 2. Design Features

### APB Slave RTL

* APB3 protocol compliant
* 4 × 32-bit internal registers
* Supports read and write transactions
* Zero wait states (PREADY always high)
* No error response support (PSLVERR always low)

### Verification Environment

* SystemVerilog testbench
* APB write and read tasks
* Directed stimulus
* Self-checking readback comparison
* Behavioral simulation using Vivado XSIM

---

## 3. File Structure

```
APB_Slave/
├── apb_slave.sv     # APB slave RTL design
├── apb_tb.sv        # SystemVerilog testbench
└── README.md        # Project documentation
```

---

## 4. APB Protocol Summary

Each APB transfer consists of two phases:

### Setup Phase

* PSEL = 1
* PENABLE = 0
* Address and control signals are valid

### Access Phase

* PSEL = 1
* PENABLE = 1
* Transfer completes when PREADY = 1

This design implements a zero wait-state slave, so each transfer completes in a single access cycle.

---

## 5. Register Map

| Address | Register | Description              |
| ------: | -------- | ------------------------ |
|    0x00 | REG0     | General-purpose register |
|    0x04 | REG1     | General-purpose register |
|    0x08 | REG2     | General-purpose register |
|    0x0C | REG3     | General-purpose register |

Register selection is performed using `PADDR[3:2]`.

---

## 6. Simulation Procedure (Vivado 2025)

1. Open **Vivado 2025.1**
2. Create a new **RTL Project**
3. Add `apb_slave.sv` as a Design Source
4. Add `apb_tb.sv` as a Simulation Source
5. Set `apb_tb` as the simulation top module
6. Run:

   **Run Simulation → Run Behavioral Simulation**

Expected console output:

```
APB TEST PASSED
```

---

## 7. Testbench Operation

The testbench performs the following steps:

1. Applies reset and initializes all APB signals
2. Writes known data values to selected registers
3. Reads back the same registers
4. Compares read data against expected values
5. Reports an error on mismatch or prints a pass message

The testbench is fully self-checking and does not require manual waveform inspection to determine pass or fail.

---

## 8. Output Waveform Explanation

The simulation waveform clearly shows correct APB behavior:

### Clock and Reset

* **PCLK** runs continuously throughout the simulation
* **PRESETn** is asserted low initially and then released
* All internal registers are reset to zero before any transfer begins

### Write Transaction Example

* **PSEL** is asserted to select the slave
* **PENABLE** is asserted in the following cycle
* **PWRITE** is high during write operations
* **PADDR** and **PWDATA** remain stable during the access phase
* On the rising edge with PSEL and PENABLE high, data is written into the selected register

### Read Transaction Example

* **PWRITE** is low during read operations
* **PRDATA** reflects the contents of the addressed register
* Read data matches the previously written values

### Control Signals

* **PREADY** remains high, indicating zero wait states
* **PSLVERR** remains low, indicating no error response
* **PSEL** deasserts cleanly after each completed transfer

The waveform confirms correct protocol timing, address decoding, and data integrity.

---

## 9. Observed Results

* APB setup and access phases are protocol correct
* Register write and read operations function as expected
* No protocol violations observed
* Simulation completes successfully with a pass message

---

## 10. Known Limitations

* No programmable wait states
* No error response logic
* Directed testing only (no random stimulus)

These limitations are intentional to keep the design simple and easy to understand.

---

## 11. Possible Extensions

* Add APB protocol assertions
* Add functional coverage
* Introduce randomized transactions
* Implement wait-state support using PREADY
* Convert testbench to class-based architecture
* Extend design to AXI4-Lite

---

## 12. Intended Use

This project is suitable for:

* Learning APB protocol fundamentals
* RTL and verification practice
* Academic labs
* Entry-level VLSI verification interviews

---

This README documents a complete, correct, and verified APB slave implementation using SystemVerilog and Vivado 2025.
