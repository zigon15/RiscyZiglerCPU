`timescale 1ns / 1ps

module BusController #(
    parameter BUS_WORD_ADDR_WIDTH = 16
    )(
    input [2:0] i_BusMode,

    //Bus Out
    output [BUS_WORD_ADDR_WIDTH - 1:0] o_Out_Addr,
    input [31:0] i_Out_RD,
    output reg [3:0] o_ByteEn,
    output reg [31:0] o_Out_WD,

    //Bus In
    input [31:0] i_In_Addr,
    output reg [31:0] o_In_RD,
    input [31:0] i_In_WD
    );
        
    initial begin
        o_ByteEn <= 4'b0;
        o_Out_WD <= 32'b0;
        o_In_RD <= 32'b0;
    end

    wire w_Signed = !i_BusMode[2];

    //Translate the byte address to a word address
    assign o_Out_Addr = {i_In_Addr[(BUS_WORD_ADDR_WIDTH-1) + 2:2]};

    parameter p_BUS_BYTE_ACCESS         = 2'b00;
    parameter p_BUS_HALF_WORD_ACCESS    = 2'b01;
    parameter p_BUS_WORD_ACCESS         = 2'b10;

    always @(*) begin
        case (i_BusMode[1:0])
            p_BUS_BYTE_ACCESS:begin
                //Take care of sign extension for the signed/unsigned byte loads
                o_In_RD[31:8] <= {{24{w_Signed & i_Out_RD[7]}}};
                o_ByteEn <= 1'b1 << i_In_Addr[1:0];

                case (i_In_Addr[1:0])
                    0:begin
                        o_In_RD[7:0] <= i_Out_RD[7:0];
                        o_Out_WD[7:0] <= i_In_WD[7:0];
                    end
                    1:begin
                        o_In_RD[7:0] <= i_Out_RD[15:8];
                        o_Out_WD[15:8] <= i_In_WD[7:0];
                    end
                    2:begin
                        o_In_RD[7:0] <= i_Out_RD[23:16];
                        o_Out_WD[23:16] <= i_In_WD[7:0];
                    end
                    3:begin
                        o_In_RD[7:0] <= i_Out_RD[31:24];
                        o_Out_WD[31:24] <= i_In_WD[7:0];
                    end 
                endcase
            end
            p_BUS_HALF_WORD_ACCESS:begin
                //Take care of sign extension for the signed/unsigned half word loads
                o_In_RD[31:16] <= {{16{w_Signed & i_Out_RD[15]}}};

                case (i_In_Addr[1:0])
                    0:begin
                        o_In_RD[15:0] <= i_Out_RD[15:0];
                        o_Out_WD[15:0] <= i_In_WD[15:0];
                        o_ByteEn <= 4'b0011;
                    end
                    1:begin
                        o_In_RD[15:0] <= i_Out_RD[23:8];
                        o_Out_WD[23:8] <= i_In_WD[15:0];
                        o_ByteEn <= 4'b0110;
                    end
                    2:begin
                        o_In_RD[15:0] <= i_Out_RD[31:16];
                        o_Out_WD[31:16] <= i_In_WD[15:0];
                        o_ByteEn <= 4'b1100;
                    end
                endcase
            end
            p_BUS_WORD_ACCESS:begin
                o_In_RD <= i_Out_RD;
                o_Out_WD <= i_In_WD;
                o_ByteEn <= 4'b1111;
            end
        endcase
    end

endmodule