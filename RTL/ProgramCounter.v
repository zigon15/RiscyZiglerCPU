`timescale 1ns / 1ps

module ProgramCounter #(
    parameter INITAL_PC_VALUE = 0
    )(
    input i_Clk,
    input i_Rst,

    output [31:0] o_PC,
    output [31:0] o_PrevPC,
    input i_EN,
    input [31:0] i_NewPC
    );

    reg [31:0] r_PC = INITAL_PC_VALUE;
    reg [31:0] r_OldPC = 32'b0;

    assign o_PC = r_PC;
    assign o_PrevPC = r_OldPC;
    
    always @(posedge i_Clk) begin
        if(i_Rst)begin
            r_PC <= INITAL_PC_VALUE;
            r_OldPC <= 32'b0;
        end else begin
            if(i_EN)begin
                r_PC <= i_NewPC;
                r_OldPC <= r_PC;
            end
        end
    end
endmodule
