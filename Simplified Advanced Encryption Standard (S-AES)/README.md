# Simplified Advanced Encryption Standard (S-AES) – FPGA Implementation

## Overview

S-AES is a pedagogical version of the AES encryption algorithm. It operates on:

- **16-bit plaintext**
- **16-bit master key**
- **16-bit ciphertext**

The purpose of this project is to understand the hardware implementation of a modern **Substitution-Permutation Network (SPN)** cipher while making efficient use of FPGA resources.

The design uses **Block RAM-based lookup tables** for the S-Box and Round Constants and follows a **sequential architecture** to reuse the required transformation hardware.

---

# 1. S-AES Encryption Architecture

(Master Key: 2D65)

The complete encryption process is:

```text
                    Master Key
                        │
                        ▼
                 ┌─────────────┐
                 │ Key         │
                 │ Expansion   │
                 └──────┬──────┘
                        │
              ┌─────────┼─────────┐
              ▼         ▼         ▼
             K0        K1        K2
              │         │         │
              │         │         │
Plaintext ─────┘        │         │
     │                  │         │
     ▼                  │         │
 AddRoundKey            │         │
 (XOR with K0)          │         │
     │                  │         │
     ▼                  │         │
 NibbleSub              │         │
     │                  │         │
     ▼                  │         │
 ShiftRows              │         │
     │                  │         │
     ▼                  │         │
 MixColumns             │         │
     │                  │         │
     ▼                  │         │
 AddRoundKey ───────────┘         │
 (XOR with K1)                    │
     │                            │
     ▼                            │
 NibbleSub                        │
     │                            │
     ▼                            │
 ShiftRows                        │
     │                            │
     ▼                            │
 AddRoundKey ─────────────────────┘
 (XOR with K2)
     │
     ▼
 Ciphertext
```text
---

#2. Memory Management and Lookup Table Implementation

The S-AES implementation uses FPGA memory resources to store fixed lookup tables instead of implementing the tables using large amounts of combinational logic.

Two lookup tables are stored in memory:

I. S-Box
II. Round Constants (Rcon)
