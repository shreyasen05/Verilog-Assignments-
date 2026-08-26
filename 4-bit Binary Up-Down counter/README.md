# 4-bit Binary Up/Down Counter

## Overview

This project implements a 4-bit binary up/down counter using Verilog HDL.

The counter counts upward or downward at approximately 2 Hz, with the counting direction controlled by a board switch. Since the FPGA operates at 100 MHz, a clock divider is used to generate a slow clock so that the counter changes can be observed on the LEDs.

The design uses a structural 4-bit adder/subtractor built using four 1-bit full adders.

## Features

- 4-bit binary up/down counter
- Structural 4-bit adder/subtractor
- Full-adder based design
- Asynchronous reset
- Approximately 2 Hz counting rate
- 100 MHz clock divider
- Direction control using a board switch
- LED-based output visualization
- FPGA implementation on Artix A7-100T

## Operation

When `direction = 1`, the counter counts up:

0000 → 0001 → 0010 → 0011 → ... → 1111 → 0000

When `direction = 0`, the counter counts down:

0000 → 1111 → 1110 → 1101 → ... → 0001 → 0000

The counter is reset to `0000` when the asynchronous reset is asserted.

