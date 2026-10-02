#include<stdio.h>
#include<stdint.h>
#include <stdlib.h>
#include <string.h>

#define IR 1024 //instruction memory size: 32x1024
#define DM 1024 //data memory size: 32x1024

typedef struct{
        uint32_t x[32];
        uint32_t pc;
}CPU;

uint32_t instruction_memory[IR];
uint32_t data_memory[DM];

//------------LOAD MEMORY--------------------------//
int load_memory(const char *bin_file){
        FILE *f;
        f = fopen(bin_file, "r");

        char line[100];

        if(f == NULL){
                printf("ERROR: can't open memory file\n");
                return 0;
        }

        if(fgets(line, sizeof(line), f) == NULL){
                printf("ERROR: the memory file is empty\n");
                fclose(f);
                return 0;
        }

        int address = 0;
        while(fgets(line, sizeof(line), f) != NULL){     //load instructions till the mem file has instructions
                uint32_t instruction;

                if(sscanf(line, "%x", &instruction) == 1){    //check if we are actually getting the hex value from the line or not
                        instruction_memory[address]=instruction;
                        address++;
                }
        }

        fclose(f);
        printf("Loaded %d instructions\n",address);
        return 1;
}

//--------------RESET CPU----------------------------------//
void reset_cpu(CPU *cpu){
        for(int i=0; i<32; i++){
                cpu->x[i] = 0;
        }
        cpu->pc = 0;

        for(int i = 0; i < DM; i++){
            data_memory[i] = 0;
        }
}
//--------------WRITE to REGISTER-----------------------------//
void reg_write(CPU *cpu, int rd, uint32_t value){
        if(rd != 0){
                cpu->x[rd] = value;
        }
}

//----------------SIGN EXTEND 12-bit IMMEDIATE--------------------------//
int32_t sign_extend_imm(uint32_t imm){
        if(imm & 0x800){
                return (int32_t)(imm | 0xFFFFF000);
        }
        return (int32_t)imm;
}

//---------------INSTRUCTION EXECUTION------------------------//
int execute_instruction(uint32_t instruction, CPU *cpu){
        uint32_t opcode = instruction & 0x7F;
        uint32_t rd = (instruction >> 7) & 0x1F;
        uint32_t funct3 = (instruction >> 12) & 0x07;
        uint32_t rs1 = (instruction >> 15) & 0x1F;
        uint32_t rs2 = (instruction >> 20) & 0x1F;
        uint32_t funct7 = (instruction >> 25) & 0x7F;


        switch(opcode){
            //--------------R-Type Instruction------------------//
            case 0x33:{
                switch(funct3){
                    case 0b000:{ //ADD or SUB
                        switch(funct7){
                            case 0b0000000:{ //ADD
                                uint32_t result = cpu->x[rs1] + cpu->x[rs2];
                                reg_write(cpu, rd, result);
                                return 1;}

                            case 0b0100000:{ //SUB
                                uint32_t result = cpu->x[rs1] - cpu->x[rs2];
                                reg_write(cpu, rd, result);
                                return 1;}

                            default: break;
                        }
                    break;
                    }
                    case 0b111:{ //AND
                        uint32_t result = cpu->x[rs1] & cpu->x[rs2];
                        reg_write(cpu, rd, result);
                        return 1;
                    }
                    case 0b110:{ //OR
                        uint32_t result = cpu->x[rs1] | cpu->x[rs2];
                        reg_write(cpu, rd, result);
                        return 1;
                    }
                    case 0b100:{ //XOR
                        uint32_t result = cpu->x[rs1] ^ cpu->x[rs2];
                        reg_write(cpu, rd, result);
                        return 1;
                    }
                    default: break;
                }
            break;
            }
            //--------------I-Type Instruction------------------//
            case 0x13:{
                uint32_t imm = (instruction >> 20) & 0xFFF;
                int32_t immediate = sign_extend_imm(imm);
                switch(funct3){
                    case 0b000:{ //ADDI
                        uint32_t result = cpu->x[rs1] + immediate;
                        reg_write(cpu, rd, result);
                        return 1;
                    }
                    case 0b111:{ //ANDI
                        uint32_t result = cpu->x[rs1] & immediate;
                        reg_write(cpu, rd, result);
                        return 1;
                    }
                    case 0b110:{ //ORI
                        uint32_t result = cpu->x[rs1] | immediate;
                        reg_write(cpu, rd, result);
                        return 1;
                    }
                }
            break;
            }
            //----------------Load Instruction------------------------//
            case 0x03:{
                uint32_t imm = (instruction >> 20) & 0xFFF;
                int32_t immediate = sign_extend_imm(imm);
                switch(funct3){
                    case 0b010:{  //LW
                        uint32_t mem_address = cpu->x[rs1] + immediate;
                        if (mem_address/4 >= DM) {
                            printf("Error: data memory address out of range\n");
                                return 0;
                        }
                        uint32_t data = data_memory[mem_address/4];
                        reg_write(cpu, rd, data);
                        return 1;
                    }
                    default : break;
                }
                break;
            }
            //-----------------S-Type Instruction--------------------//
            case 0x23:{ 
                uint32_t imm = 
                  ((instruction >> 25) & 0x7F) << 5
                | ((instruction >> 7) & 0x1F);
                int32_t immediate = sign_extend_imm(imm);
                switch(funct3){
                    case 0b010:{ //SW
                        uint32_t mem_address = cpu->x[rs1] + immediate;
                        if (mem_address/4 >= DM) {
                            printf("Error: data memory address out of range\n");
                                return 0;
                        }
                        data_memory[mem_address/4] = cpu->x[rs2];
                        return 1;
                    }
                    default : break;
                }
                break;
            }
            //----------------J-Type Instruction----------------------//
            case 0x6F: { // JAL

                uint32_t imm =
                  ((instruction >> 31) & 0x1) << 20
                | ((instruction >> 12) & 0xFF) << 12
                | ((instruction >> 20) & 0x1) << 11
                | ((instruction >> 21) & 0x3FF) << 1;

                // sign extend 21-bit immediate
                if (imm & 0x100000) {
                    imm |= 0xFFE00000;
                }
                uint32_t return_address = cpu->pc + 4;
                cpu->pc = cpu->pc + (int32_t)imm;

                reg_write(cpu, rd, return_address);

                return 1;
             }
             //----------------B-Type Instruction-------------------//
             case 0x63: {  //BEQ, BNE
                uint32_t imm =
                  ((instruction >> 31) & 0x1) << 12
                | ((instruction >> 7) & 0x1) << 11
                | ((instruction >> 25) & 0x3F) << 5
                | ((instruction >> 8) & 0xF) << 1;

                // sign extend 13-bit immediate
                if(imm & 0x1000){
                    imm |= 0xFFFFE000;
                }
                switch(funct3){  //BEQ
                    case 0b000:{
                        if(cpu->x[rs1] == cpu->x[rs2]){
                            cpu->pc += (int32_t)imm;
                        }else{
                            cpu->pc += 4;
                        }
                        return 1;
                    }
                    case 0b001:{  //BNE
                        if(cpu->x[rs1] != cpu->x[rs2]){
                            cpu->pc += (int32_t)imm;
                        }else{
                            cpu->pc += 4;
                        }
                        return 1;
                    }
                    default : break;
                }
                break;
            }
            //-----------------U-Type Instruction-------------------//
            case 0x37:{
                uint32_t imm = instruction & 0xFFFFF000;
                reg_write(cpu, rd, imm);
                return 1;
            }
            //-----------------Unsupported Instruction-------------------//
            default:{
                printf("Error: unsupported instruction 0x%08x at PC = 0x%08x\n",instruction,cpu->pc);
                return 0;
            }
        }
	return 0;
}

void print_help(const char *program_name)
{
    printf("RISC-V RV32I Simulator\n\n");
    printf("Usage:\n");
    printf("  %s --mem <memory_file> --max-cycles <number>\n", program_name);
    printf("  %s --help\n\n", program_name);

    printf("Options:\n");
    printf("  --mem <file>          Input memory image\n");
    printf("  --max-cycles <number> Maximum number of cycles to run\n");
    printf("  --help                Show this help message\n");
}

//---------------Main CPU-----------------//
int main(int argc, char *argv[])
{
    CPU cpu;

    const char *memory_file = NULL;
    int max_cycles = 100;

    // Parse command-line arguments 
    for (int i = 1; i < argc; i++) {

        if (strcmp(argv[i], "--help") == 0) {
            print_help(argv[0]);
            return 0;
        }

        else if (strcmp(argv[i], "--mem") == 0) {

            if (i + 1 >= argc) {
                printf("ERROR: --mem requires a file name\n");
                return 1;
            }

            memory_file = argv[++i];
        }

        else if (strcmp(argv[i], "--max-cycles") == 0) {

            if (i + 1 >= argc) {
                printf("ERROR: --max-cycles requires a number\n");
                return 1;
            }

            max_cycles = atoi(argv[++i]);

            if (max_cycles <= 0) {
                printf("ERROR: max-cycles must be greater than 0\n");
                return 1;
            }
        }

        else {
            printf("ERROR: unknown option: %s\n", argv[i]);
            printf("Use --help for usage information.\n");
            return 1;
        }
    }

    // Check that memory file was provided
    if (memory_file == NULL) {
        printf("ERROR: no memory file specified\n");
        printf("Use --help for usage information.\n");
        return 1;
    }

    // Reset CPU
    reset_cpu(&cpu);

    // Load program
    if (!load_memory(memory_file)) {
        return 1;
    }

    printf("\nStarting processor...\n\n");

    /* =========================
       FETCH-DECODE-EXECUTE LOOP
       ========================= */

    for (int cycle = 0; cycle < max_cycles; cycle++) {

        // Convert byte PC to instruction-memory index
        uint32_t index = cpu.pc / 4;

        uint32_t instruction =
            instruction_memory[index];


        printf("Cycle %d\n", cycle + 1);
        printf("  PC          = 0x%08x\n", cpu.pc);
        printf("  Instruction = 0x%08x\n", instruction);


        // Execute

        if (!execute_instruction(instruction, &cpu)) {
            printf("\nProcessor stopped.\n");
            return 1;
        }

        // PC increment 
        uint32_t opcode = instruction & 0x7F;
        if (opcode != 0x6F && opcode != 0x63) {
            cpu.pc += 4;
        }

        cpu.x[0] = 0; //x0 = 0 always
    }
    printf("Maximum cycle count reached.\n");

    /* =========================
       FINAL STATE
       ========================= */

    printf("\n========== FINAL CPU STATE ==========\n");

    printf("PC = 0x%08x\n", cpu.pc);

    for (int i = 0; i < 32; i++) {
        printf("x%-2d = %u\n", i, cpu.x[i]);
    }
    printf("\n========== DATA MEMORY ==========\n");

    for (int i = 0; i < 10; i++) {
        printf("memory[%d] = %u (0x%08x)\n",i, data_memory[i], data_memory[i]);
    }
    return 0;
}
