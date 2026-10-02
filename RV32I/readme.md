## Supported Instructions

- R-type: `ADD`, `SUB`, `AND`, `OR`, `XOR`
- I-type: `ADDI`, `ANDI`, `ORI`
- Memory: `LW`, `SW`
- Branches: `BEQ`, `BNE`
- Jump: `JAL`
- Upper immediate: `LUI`

## Build and Run the RISC-V Test Program

1.Compile an assembly test using the RISC-V GNU toolchain:
```sh
riscv64-unknown-elf-gcc \
  -march=rv32i \
  -mabi=ilp32 \
  -nostdlib \
  -nostartfiles \
  -ffreestanding \
  -Wl,-Ttext=0x0 \
  -Wl,-e,_start \
  tests/asm/fibonacci.S \
  -o build/fibonacci.elf
```

2.Convert the ELF file to a binary image:
```sh
riscv64-unknown-elf-objcopy \
  -O binary \
  build/fibonacci.elf \
  build/fibonacci.bin
```

3.Convert the binary image to the simulator's .mem format:
```sh
python3 tools/bin_to_mem.py \
  build/fibonacci.bin \
  build/fibonacci.mem
Build the Simulator
```

4.Compile the C simulator using the host GCC compiler:
```sh
gcc -Wall -Wextra src/main.c -o build/riscv-sim
```

5.Run the simulator using the generated memory image:
```sh
./build/riscv-sim \
  --mem build/fibonacci.mem \
  --max-cycles 100
```

## Command-line Options

--mem <file>           Input memory image
--max-cycles <number>  Maximum number of cycles
--help                 Show help