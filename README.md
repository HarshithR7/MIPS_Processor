I have Implemented 2 MIPS processors which executes MIPS instructions in a single clock cycle and through basic 4 pipeline stages.

Program Counter (PC): Maintains the address of the current instruction

ALU: Performs arithmetic and logical operations

Control Unit: Generates control signals based on instruction opcode

Register File: Stores temporary data

Data Memory: Stores program data

Instruction Memory: Stores program instructions

# Instruction Support
# R-Type Instructions
Arithmetic: ADD, SUB
Logical: AND, OR
Shifts: SLL, SRL, SRA

# I-Type Instructions
Memory: LW (Load Word), SW (Store Word)
Immediate: ADDI, ANDI, ORI

# Branch: 
BEQ (Branch if Equal), BNE (Branch if Not Equal)

# J-Type Instructions
J (Jump)
