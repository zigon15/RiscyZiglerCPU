`timescale 1ns / 1ps

module RegisterFile_tb();
    reg r_Clk = 0;
    reg r_Rst = 0;

    reg [4:0] r_Addr1 = 0;
    reg [4:0] r_Addr2 = 0;
    reg [4:0] r_Addr3 = 0;

    wire [31:0] w_RD1;
    wire [31:0] w_RD2;

    reg r_WE3 = 0;
    reg [31:0] r_WD3 = 0;

    //Device under test
    RegisterFile #(
        .REG_WIDTH(32),
        .REG_DEPTH(32)
    )DUT(
        .i_Clk(r_Clk),
        .i_Rst(r_Rst),

        .i_Addr1(r_Addr1),
        .i_Addr2(r_Addr2),
        .i_Addr3(r_Addr3),

        .o_RD1(w_RD1),
        .o_RD2(w_RD2),

        .i_WE3(r_WE3),
        .i_WD3(r_WD3)
    );

    //Generate the clock and reset signals
    initial begin
        r_Clk = 1'b0;
        r_Rst = 1'b1;
        repeat(4) #10 r_Clk = ~r_Clk;
        r_Rst = 1'b0;
        forever #10 r_Clk = ~r_Clk;
    end

    initial begin
        // wait for reset
        @(negedge r_Rst);
        @(posedge r_Clk);
        
        r_Addr1 <= 2;
        r_Addr2 <= 2;
        r_Addr3 <= 2;
        r_WD3 <= 32'hAAAAAAAA;
        r_WE3 <= 1'b1;
        @(posedge r_Clk);

        r_WD3 <= 32'h55555555;
        r_WE3 <= 1'b0;
        @(posedge r_Clk);

        r_Addr1 <= 31;
        r_Addr3 <= 31;
        r_WD3 <= 32'hFFFFFFFF;
        r_WE3 <= 1'b1;
        @(posedge r_Clk);

        //Chekc that writing/reading register 0 always returns 0
        r_Addr1 <= 0;
        r_Addr3 <= 0;
        r_WD3 <= 32'hFFFFFFFF;
        r_WE3 <= 1'b1;
        @(posedge r_Clk);

        r_WE3 <= 1'b0;
        @(posedge r_Clk);
    end
endmodule
