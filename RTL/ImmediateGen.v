`timescale 1ns / 1ps

module ImmediateGen(
    input [6:0] i_OpCode,
    input [31:0] i_Inst,
    output reg [31:0] o_Immediate
    );

    //Opcodes that require immediates
    parameter p_InstType_B      = 7'b1100011;
    parameter p_InstType_S      = 7'b0100011;
    parameter p_InstType_I      = 7'b0010011;
    parameter p_InstType_L      = 7'b0000011;
    parameter p_InstType_JALR   = 7'b1100111;
    parameter p_InstType_LUI    = 7'b0110111;
    parameter p_InstType_AUIP   = 7'b0010111;
    parameter p_InstType_JAL    = 7'b1101111;

    always @(*) begin
        case (i_OpCode)
            p_InstType_B:begin
                o_Immediate <= {{20{i_Inst[31]}}, i_Inst[7], i_Inst[30:25], i_Inst[11:8], 1'b0};
            end
            p_InstType_S:begin
                o_Immediate <= {{21{i_Inst[31]}}, i_Inst[30:25], i_Inst[11:8], i_Inst[7]};
            end
            p_InstType_I:begin
                o_Immediate <= {{21{i_Inst[31]}}, i_Inst[30:20]};
            end
            p_InstType_L:begin
                o_Immediate <= {{21{i_Inst[31]}}, i_Inst[30:20]};
            end
            p_InstType_JALR:begin
                o_Immediate <= {{21{i_Inst[31]}}, i_Inst[30:20]};
            end
            p_InstType_LUI:begin
                o_Immediate <= {i_Inst[31:12], 12'b0};
            end
            p_InstType_AUIP:begin
                o_Immediate <= {i_Inst[31:12], 12'b0};
            end
            p_InstType_JAL:begin
                o_Immediate <= {{12{i_Inst[31]}}, i_Inst[19:12], i_Inst[20], i_Inst[30:21], 1'b0};
            end
            default:begin
                o_Immediate <= 32'b0;
            end
        endcase
    end

endmodule
