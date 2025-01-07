`timescale 1ns / 1ps
// Top-level module
module mips_processor(
    input clk, reset,
    output [31:0] result
);
    // Internal wires
    wire [31:0] pc_current, pc_next, pc_plus4;
    wire [31:0] instruction;
    wire [31:0] read_data1, read_data2;
    wire [31:0] write_data;
    wire [31:0] sign_extended;
    wire [31:0] alu_result;
    wire [31:0] mem_read_data;
    wire [31:0] alu_in2;
    wire [31:0] branch_target;
    wire [31:0] jump_target;
    wire [31:0] branch_or_pc4;
    wire zero;
    wire branch_taken;
    wire [31:0] pc_next;
    wire [31:0] shifted_address;
    
    // Control signals
    wire reg_dst, branch, mem_read, mem_to_reg;
    wire mem_write, alu_src, reg_write, jump;
    wire [3:0] alu_op;
    wire is_shift;
    wire branch_type;
    
    // Instruction fields
    wire [4:0] write_reg_addr;
    wire [4:0] shamt;
    assign shamt = instruction[10:6];
    
    // Program Counter
    program_counter pc(
        .clk(clk),
        .reset(reset),
        .pc_in(pc_next),
        .pc_out(pc_current)
    );

    // PC + 4 Adder
    adder pc_plus4_adder(
        .a(pc_current),
        .b(32'd4),
        .result(pc_plus4)
    );

    // Instruction Memory
    instruction_memory imem(
        .pc(pc_current),
        .instruction(instruction)
    );

    // Control Unit
    control_unit control(
        .opcode(instruction[31:26]),
        .funct(instruction[5:0]),
        .reg_dst(reg_dst),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .jump(jump),
        .branch_type(branch_type),
        .is_shift(is_shift)
    );

    // Register File
    register_file regfile(
        .clk(clk),
        .reset(reset),
        .read_reg1(instruction[25:21]),
        .read_reg2(instruction[20:16]),
        .write_reg(write_reg_addr),
        .write_data(write_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Sign Extend
    sign_extend sign_ext(
        .in(instruction[15:0]),
        .out(sign_extended)
    );

    // ALU
    alu main_alu(
        .a(read_data1),
        .b(alu_in2),
        .shamt(shamt),
        .alu_control(alu_op),
        .is_shift(is_shift),
        .result(alu_result),
        .zero(zero)
    );

    // Data Memory
    data_memory dmem(
        .clk(clk),
        .address(alu_result),
        .write_data(read_data2),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(mem_read_data)
    );

    // Multiplexers
    mux_2to1 #(5) reg_mux(
        .in0(instruction[20:16]),
        .in1(instruction[15:11]),
        .sel(reg_dst),
        .out(write_reg_addr)
    );

    mux_2to1 alu_src_mux(
        .in0(read_data2),
        .in1(sign_extended),
        .sel(alu_src),
        .out(alu_in2)
    );

    mux_2to1 mem_to_reg_mux(
        .in0(alu_result),
        .in1(mem_read_data),
        .sel(mem_to_reg),
        .out(write_data)
    );

    // Branch and Jump Logic
    shift_left_2 branch_shift(
        .in(sign_extended),
        .out(shifted_address)
    );

    adder branch_adder(
        .a(pc_plus4),
        .b(shifted_address),
        .result(branch_target)
    );

    assign branch_taken = branch & (branch_type ? !zero : zero);
    assign branch_target= pc_plus4 + (shifted_address);
    assign jump_target = {pc_plus4[31:28], instruction[25:0], 2'b00};
    assign pc_next = jump ? jump_target :branch_taken ? branch_target :pc_plus4;
    wire [31:0] branch_or_pc4;
    mux_2to1 branch_mux(
        .in0(pc_plus4),
        .in1(branch_target),
        .sel(branch_taken),
        .out(branch_or_pc4)
    );

    mux_2to1 jump_mux(
        .in0(branch_or_pc4),
        .in1(jump_target),
        .sel(jump),
        .out(pc_next)
    );

    // Output
    assign result = alu_result;
endmodule