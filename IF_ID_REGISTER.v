`timescale 1ns / 1ps
// IF/ID Pipeline Register
module IF_ID_reg (
    input clk,
    input reset,
    input [31:0] instruction_in,
    input [31:0] pc_plus4_in,
    output reg [31:0] instruction_out,
    output reg [31:0] pc_plus4_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction_out <= 32'b0;
            pc_plus4_out <= 32'b0;
        end else begin
            instruction_out <= instruction_in;
            pc_plus4_out <= pc_plus4_in;
        end
    end
endmodule

