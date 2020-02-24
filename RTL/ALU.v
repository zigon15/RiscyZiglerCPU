`timescale 1ns / 1ps

module ALU(
    input [3:0] i_OpCode,

    input [1:0] i_SrcASel,
    input signed [31:0] i_SrcA0,
    input signed [31:0] i_SrcA1,
    input signed [31:0] i_SrcA2,
    
    input [1:0] i_SrcBSel,
    input signed [31:0] i_SrcB0,
    input signed [31:0] i_SrcB1,
    input signed [31:0] i_SrcB2,
    input signed [31:0] i_SrcB3,

    output [31:0] o_Result,
    output o_Zero
    );

    assign o_Zero = (r_Result == 32'b0) ? 1'b1 : 1'b0;

    reg [31:0] r_Result = 32'b0;
    assign o_Result = r_Result;

    //The various ALU operations
    parameter ALU_ADD   = 4'b0000;
    parameter ALU_SUB   = 4'b1000;
    parameter ALU_AND   = 4'b0111;
    parameter ALU_OR    = 4'b0110;
    parameter ALU_XOR   = 4'b0100;
    parameter ALU_SLL   = 4'b0001;
    parameter ALU_SRL   = 4'b0101;
    parameter ALU_SRA   = 4'b1101;

    wire [31:0]w_SrcA[2:0] = {i_SrcA2, i_SrcA1, i_SrcA0};
    wire [31:0]w_SrcB[3:0] = {i_SrcB3, i_SrcB2, i_SrcB1, i_SrcB0};

    always @(*) begin
        case (i_OpCode)
            ALU_ADD:begin
                r_Result <= w_SrcA[i_SrcASel] + w_SrcB[i_SrcBSel];
            end
            ALU_SUB:begin
                r_Result <= w_SrcA[i_SrcASel] - w_SrcB[i_SrcBSel];
            end  
            ALU_AND:begin
                r_Result <= w_SrcA[i_SrcASel] & w_SrcB[i_SrcBSel];
            end  
            ALU_OR:begin
                r_Result <= w_SrcA[i_SrcASel] | w_SrcB[i_SrcBSel];
            end
            ALU_XOR:begin
                r_Result <= w_SrcA[i_SrcASel] ^ w_SrcB[i_SrcBSel];
            end  
            ALU_SLL:begin
                r_Result <= w_SrcA[i_SrcASel] << w_SrcB[i_SrcBSel][4:0];
            end  
            ALU_SRL:begin
                r_Result <= w_SrcA[i_SrcASel] >> w_SrcB[i_SrcBSel][4:0];
            end  
            ALU_SRA:begin
                r_Result <= w_SrcA[i_SrcASel] >>> w_SrcB[i_SrcBSel][4:0];
            end  
        endcase
    end

endmodule
