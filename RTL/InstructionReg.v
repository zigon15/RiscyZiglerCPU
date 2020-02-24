`timescale 1ns / 1ps

module InstructionReg(
    input i_Clk,
    input i_Rst,

    input i_Wr,
    input [31:0] i_Data,

    output [31:0] o_Instruction
    );

    assign o_Instruction = i_Wr? i_Data: r_Instruction;

    reg [31:0] r_Instruction = 0;

    always @(posedge i_Clk) begin
        if(i_Rst)begin
            r_Instruction <= 0;
        end else begin
            if(i_Wr)begin
                r_Instruction <= i_Data;
            end
        end
    end

endmodule
