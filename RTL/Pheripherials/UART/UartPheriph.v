`timescale 1ns / 1ps

module UartPheriph #(
    parameter ADDR_WIDTH = 16,
    parameter ADDR_BITS_PER_CHUCK = 6,
    parameter ADDR_BLOCK = 0
    )(
    input i_Clk,
    input i_Rst,

    //UART
    output o_UART_TX,

    //Simple bus slave
    input [ADDR_WIDTH-1: 0] i_Addr,
    output [31:0] o_RD,
    input i_WE,
    input [3:0] i_ByteEn,
    input [31:0] i_WD
    );

    reg [31:0] r_RD = 0;
    assign o_RD = w_Sel? r_RD: 32'bz;

    wire w_TXIdle;
    reg r_TXEn = 1'b0;

    //True if this slave is selected
    wire w_Sel = (i_Addr[ADDR_WIDTH-1 :ADDR_BITS_PER_CHUCK] == ADDR_BLOCK)? 1: 0;
    wire [ADDR_BITS_PER_CHUCK-1:0] w_Addr = i_Addr[ADDR_BITS_PER_CHUCK-1:0];

    //Simple bus addressable registers
    reg [15:0] r_Reg_ClksPerBit = 0;
    reg [7:0] r_Reg_DataWR = 0;
    reg [7:0] r_Reg_DataRD = 0;

    //The various register addresses
    parameter p_REG_ADDR_CTRL   = 0;
    parameter p_REG_ADDR_DATA   = 1;

    UartTx TX(
        .i_Clk(i_Clk),
        .i_Rst(i_Rst),

        .o_UART_TX(o_UART_TX),
        
        .i_ClksPerBit(r_Reg_ClksPerBit),
        .i_TxEn(r_TXEn),
        .i_Data(r_Reg_DataWR[7:0]),
        .o_Idle(w_TXIdle)
    );

    always @(posedge i_Clk)begin
        if(i_Rst)begin
            r_RD <= 0;
            r_TXEn <= 0;

            //Addressable registers
            r_Reg_ClksPerBit <= 0;
            r_Reg_DataWR <= 0;
            r_Reg_DataRD <= 0;
        end else begin
            r_TXEn <= 1'b0;

            if (w_Sel) begin
                //If a transaction is taking place
                if(i_WE)begin
                    //Write transaction
                    case (w_Addr)
                        p_REG_ADDR_CTRL:begin
                            r_Reg_ClksPerBit[7:0]  = i_ByteEn[0]? i_WD[7:0] : r_Reg_ClksPerBit[7:0];
                            r_Reg_ClksPerBit[15:8] = i_ByteEn[1]? i_WD[15:8]: r_Reg_ClksPerBit[15:8];
                        end
                        p_REG_ADDR_DATA:begin
                            if(i_ByteEn[0])begin
                                r_Reg_DataWR <= i_WD[7:0];
                                r_TXEn <= 1'b1;
                            end
                        end
                    endcase

                end else begin
                    //Read transaction
                    case (w_Addr)
                        p_REG_ADDR_CTRL:begin
                            r_RD <= {15'b0, w_TXIdle, r_Reg_ClksPerBit};
                        end
                        p_REG_ADDR_DATA:begin
                            r_RD <= {24'b0, r_Reg_DataRD};
                        end
                        default:begin
                            r_RD <= 0;
                        end
                    endcase

                end
            end
        end
    end
endmodule