`timescale 1ns / 1ps
module alu(
    input [31:0] a, b,
    input [4:0] shamt,
    input [3:0] alu_control,
    input is_shift,
    output reg [31:0] result,
    output zero
    
);

    always @(*) begin
       
        case(alu_control)
            // Arithmetic operations
            4'b0000: result = a + b;    // ADDI 
            4'b0010: result = a + b;    // ADD (R-type)
            4'b1010: result = a - b;
            4'b1011: result = a - b;
       
            4'b1101:result = a-b;
            
            // Logical operations
            4'b0100: result = a & b;    // AND
            4'b0101: result = a | b;    // OR
            
            // Shift operations
            4'b0110: result = is_shift ? (b << shamt) : (a << b);   // SLL
            4'b0111: result = is_shift ? (b >> shamt) : (a >> b);   // SRL
            4'b1000: result = is_shift ? ($signed(b) >>> shamt) : ($signed(a) >>> b);   // SRA
            
         
            default: result = 32'b0;
        endcase
    end
    
    assign zero = (result == 32'b0);

endmodule
