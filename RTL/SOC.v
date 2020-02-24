`timescale 1ns / 1ps

module SOC(
    input i_Clk,
    input i_Rst,

    output o_UART_TX
    );
    parameter WORD_ADDR_WIDTH = 16;
    parameter ADDR_BITS_PER_CHUCK = 6;

    wire [WORD_ADDR_WIDTH-1: 0] w_DBus_Addr;
    wire [31:0] w_DBus_RD;
    wire w_DBus_WE;
    wire [3:0] w_DBus_ByteEn;
    wire [31:0] w_DBus_WD;

    CPU #(
        .BUS_WORD_ADDR_WIDTH(WORD_ADDR_WIDTH)
    )CPU1(
        .i_Clk(i_Clk),
        .i_Rst(i_Rst),

        //Simple bus master
        .o_DBus_Addr(w_DBus_Addr),
        .i_DBus_RD(w_DBus_RD),
        .o_DBus_WE(w_DBus_WE),
        .o_DBus_ByteEn(w_DBus_ByteEn),
        .o_DBus_WD(w_DBus_WD)
    );

    DRam #(
        .ADDR_WIDTH(WORD_ADDR_WIDTH),
        .ADDR_BITS_PER_CHUCK(ADDR_BITS_PER_CHUCK),
        .ADDR_BLOCK(0),
        .MEMORY_DEPTH(64)
    )DRAM(
        .i_Clk(i_Clk),
        .i_Rst(i_Rst),

        //Simple bus slave
        .i_Addr(w_DBus_Addr),
        .o_RD(w_DBus_RD),
        .i_WE(w_DBus_WE),
        .i_ByteEn(w_DBus_ByteEn),
        .i_WD(w_DBus_WD)
    );

    UartPheriph #(
        .ADDR_WIDTH(WORD_ADDR_WIDTH),
        .ADDR_BITS_PER_CHUCK(ADDR_BITS_PER_CHUCK),
        .ADDR_BLOCK(1)
    )UART(
        .i_Clk(i_Clk),
        .i_Rst(i_Rst),

        //Simple bus slave
        .i_Addr(w_DBus_Addr),
        .o_RD(w_DBus_RD),
        .i_WE(w_DBus_WE),
        .i_ByteEn(w_DBus_ByteEn),
        .i_WD(w_DBus_WD)
    );

endmodule
