.section .text
.globl _start

_start:

    # x1 = current Fibonacci number
    # x2 = next Fibonacci number
    # x3 = loop counter
    # x4 = memory address
    # x5 = temporary
    # x6 = next memory address

    addi x1, x0, 0          # x1 = 0
    addi x2, x0, 1          # x2 = 1
    addi x3, x0, 10         # 10 numbers
    addi x4, x0, 0          # memory address = 0


loop:

    # Store current Fibonacci number
    sw   x1, 0(x4)

    # Calculate next Fibonacci number
    add  x5, x1, x2         # x5 = x1 + x2

    # Shift values
    addi x1, x2, 0          # x1 = x2
    addi x2, x5, 0          # x2 = x5

    # Move to next memory location
    addi x4, x4, 4          # address += 4

    # Decrement counter
    addi x3, x3, -1

    # Continue until counter = 0
    bne  x3, x0, loop


end:
    jal  x0, end
