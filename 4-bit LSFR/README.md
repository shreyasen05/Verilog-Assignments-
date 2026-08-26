# 4-bit Parallel-Load LFSR
## LFSR Operation
## Overview

This project implements a 4-bit Parallel-Load Linear Feedback Shift Register (LFSR) using Verilog HDL.

The LFSR uses four D flip-flops, four 2:1 multiplexers, and XOR feedback logic. A non-zero 4-bit seed can be loaded in parallel, after which the LFSR cycles through all 15 non-zero states.

## Features

- 4-bit maximal-length LFSR
- Parallel seed loading
- 15 non-zero states
- Asynchronous reset
- Selectable seed-load and LFSR modes
- Clock divider for approximately 1 Hz operation
- FPGA implementation on Nexys 4 DDR

The feedback is generated using:

`feedback = w4 ^ w5`

The next state is:

`{w4 ^ w5, w2, w3, w4}`

When `sel = 0`, the 4-bit seed is loaded.

When `sel = 1`, the LFSR starts shifting.

## Example Sequence

For seed `1111`:

```text
1111 → 0111 → 1011 → 0101 → 0010
→ 1001 → 1100 → 0110 → 0011 → 1000
→ 0100 → 1010 → 1101 → 1110 → 0001
→ 1111