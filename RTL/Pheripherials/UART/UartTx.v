`timescale 1ns / 1ps

module UartTx (
    input i_Clk,
    input i_Rst,

    output reg o_UART_TX,

    input [15:0] i_ClksPerBit,
    input i_TxEn,
    input [7:0] i_Data,
    output reg o_Idle,
    output reg o_Done
    );

    initial begin
        o_UART_TX <= 1'b1;
        o_Idle <= 1'b1;
        o_Done <= 1'b0;
    end
    
    reg [15:0] r_ClksPerBitCounter = 16'b0;
    reg [2:0] r_BitCounter = 3'b0;

    //UART TX state machine
    localparam TX_STATE_SIZE = 2;
    localparam TX_WAIT      = 0,
               TX_START_BIT = 1,
               TX_DATA      = 2,
               TX_STOP      = 3;
    reg [TX_STATE_SIZE-1:0] TXState = TX_WAIT;
    

    always @(posedge i_Clk)begin
        if(i_Rst)begin
            o_UART_TX <= 1'b1;
            o_Idle <= 1'b1;
            o_Done <= 1'b0;
            r_ClksPerBitCounter <= 16'b0;
            r_BitCounter <= 3'b0;

            TXState <= TX_WAIT;
        end else begin
            case (TXState)
                TX_WAIT:begin
                    o_UART_TX <= 1;
                    o_Done <= 0;
                    r_ClksPerBitCounter <= 0;
                    r_BitCounter <= 0;

                    if(i_TxEn == 1)begin
                        o_Idle <= 0;
                        TXState <= TX_START_BIT;
                    end else begin
                        o_Idle <= 1;
                    end
                end
                TX_START_BIT:begin
                    o_UART_TX <= 0;

                    if(r_ClksPerBitCounter < i_ClksPerBit - 1)begin
                        r_ClksPerBitCounter <= r_ClksPerBitCounter + 1;
                    end else begin
                        r_ClksPerBitCounter <= 0;
                        TXState <= TX_DATA;
                    end
                end
                TX_DATA:begin
                    o_UART_TX <= i_Data[r_BitCounter];

                    if(r_ClksPerBitCounter < i_ClksPerBit - 1)begin
                        r_ClksPerBitCounter <= r_ClksPerBitCounter + 1;
                    end else begin
                        r_BitCounter <= r_BitCounter + 1;
                        r_ClksPerBitCounter <= 0;

                        if(r_BitCounter == 7)begin
                            r_BitCounter <= 0;
                            TXState <= TX_STOP; 
                        end
                    end
                end
                TX_STOP:begin
                    o_UART_TX <= 1;
                    if(r_ClksPerBitCounter < i_ClksPerBit - 1)begin
                        r_ClksPerBitCounter <= r_ClksPerBitCounter + 1;
                    end else begin
                        r_ClksPerBitCounter <= 0;
                        o_Done <= 1;
                        o_Idle <= 1;
                        TXState <= TX_WAIT;
                    end
                end
            endcase
        end
    end
endmodule