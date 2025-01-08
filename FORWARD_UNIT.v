`timescale 1ns / 1ps
module forwarding_unit (
    input [4:0] rs_ex,
    input [4:0] rt_ex,
    input [4:0] rd_mem,
    input [4:0] rd_wb,
    input reg_write_mem,
    input reg_write_wb,
    output reg [1:0] forward_a,
    output reg [1:0] forward_b
);
    always @(*) begin
        // A 
        if (reg_write_mem && (rd_mem != 0) && (rd_mem == rs_ex))
            forward_a = 2'b10;
        else if (reg_write_wb && (rd_wb != 0) && (rd_wb == rs_ex))
            forward_a = 2'b01;
        else
            forward_a = 2'b00;

        //  B 
        if (reg_write_mem && (rd_mem != 0) && (rd_mem == rt_ex))
            forward_b = 2'b10;
        else if (reg_write_wb && (rd_wb != 0) && (rd_wb == rt_ex))
            forward_b = 2'b01;
        else
            forward_b = 2'b00;
    end
endmodule

