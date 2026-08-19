
# Verilog Hardware Design & Simulation



This repository contains Verilog-based hardware designs, testbenches, simulation files, and the workflow for implementing the designs on FPGA hardware.

---

## Hardware Design Flow

```text
Hardware Specification
        │
        ▼
Verilog RTL Design
        │
        ▼
Testbench Development
        │
        ▼
Icarus Verilog Compilation
        │
        ▼
VVP Simulation
        │
        ▼
VCD Waveform Generation
        │
        ▼
GTKWave Analysis
        │
        ▼
RTL Verification
        │
        ▼
Synthesis
        │
        ▼
FPGA Implementation
        │
        ▼
Bitstream Generation
        │
        ▼
FPGA Programming
        │
        ▼
Hardware Testing
````

---

## Tools Used

| Tool                  | Purpose                                             |
| --------------------- | --------------------------------------------------- |
| **Verilog HDL**       | RTL hardware design                                 |
| **Icarus Verilog**    | Verilog compilation and simulation                  |
| **VVP**               | Simulation execution                                |
| **GTKWave**           | Waveform visualization and analysis                 |
| **FPGA Vendor Tools** | Synthesis, implementation, and bitstream generation |

---

## Project Structure

```text
.
├── rtl/
│   └── *.v
│
├── tb/
│   └── *_tb.v
│
├── simulation/
│   └── *.vcd
│
├── constraints/
│   └── *.xdc / *.sdc / *.pcf
│
├── README.md
└── ...
```

---

## RTL Design

The hardware functionality is first implemented using Verilog HDL.

The design is divided into appropriate modules to keep the hardware architecture modular, reusable, and easy to verify.

```text
RTL Design
    │
    ├── Datapath
    ├── Control Logic
    ├── Registers
    └── Interfaces
```

---

## Testbench

A Verilog testbench is developed to verify the RTL design before deploying it to physical hardware.

The testbench is responsible for:

* Generating clock and reset
* Providing input stimulus
* Monitoring outputs
* Generating simulation waveforms
* Verifying expected functionality

---

## Simulation with Icarus Verilog

### Compile

```bash
iverilog -o simulation.vvp rtl/*.v tb/*.v
```

### Run

```bash
vvp simulation.vvp
```

The simulation generates a waveform file such as:

```text
waveform.vcd
```

---

## Waveform Analysis with GTKWave

The generated waveform can be inspected using GTKWave:

```bash
gtkwave waveform.vcd
```

Important signals such as clock, reset, inputs, outputs, registers, and internal control signals can be analyzed to verify the design behavior.

---

## Verification Flow

```text
Write RTL
   │
   ▼
Write Testbench
   │
   ▼
Compile with Icarus Verilog
   │
   ▼
Run Simulation
   │
   ▼
Generate VCD
   │
   ▼
Analyze with GTKWave
   │
   ▼
Pass?
 ┌─┴─┐
 │   │
No  Yes
 │   │
 ▼   ▼
Fix RTL
     │
     ▼
  Synthesis
```

If the simulation does not produce the expected behavior, the RTL or testbench is modified and the simulation cycle is repeated.

---

## FPGA Hardware Implementation

Once the RTL has been successfully verified in simulation, the design is prepared for FPGA implementation.

```text
Verified RTL
     │
     ▼
Synthesis
     │
     ▼
Implementation
     │
     ▼
Timing Analysis
     │
     ▼
Bitstream Generation
     │
     ▼
FPGA Programming
     │
     ▼
Hardware Validation
```

The exact synthesis and implementation tools depend on the target FPGA platform.

---

## Hardware Validation

The final design is tested on the target FPGA board using the required interfaces and peripherals.

Hardware validation may include:

* GPIO
* UART
* USB-to-TTL
* Ethernet
* JTAG
* LEDs and switches
* External peripherals

The hardware results are compared against the behavior verified during RTL simulation.

---

## Complete Workflow

```text
                  VERILOG HARDWARE DEVELOPMENT
                              │
                              ▼
                    Hardware Specification
                              │
                              ▼
                        RTL Design
                              │
                              ▼
                       Testbench
                              │
                              ▼
                    Icarus Verilog
                              │
                              ▼
                         VVP
                              │
                              ▼
                      VCD Waveform
                              │
                              ▼
                        GTKWave
                              │
                              ▼
                     RTL Verification
                              │
                              ▼
                         Synthesis
                              │
                              ▼
                   FPGA Implementation
                              │
                              ▼
                  Bitstream Generation
                              │
                              ▼
                    FPGA Programming
                              │
                              ▼
                    Hardware Testing
```

---

## Contributors

* **Shreya Sen**
* **K. Charan**

---

## License

This repository is intended for educational and research purposes.

```
```
