`timescale 1ns / 1ps

module IDMemory_tb();
    reg r_Clk = 0;
    reg r_Rst = 0;

    reg [9:0] r_RDAddr = 0;
    wire [31:0] w_RDData;

    reg [9:0] r_WRAddr = 0;
    reg [31:0] r_WRData = 0;
    reg r_WR = 0;

    //Device under test
    IDMemory #(
        .MEMORY_WIDTH(32),
        .MEMORY_DEPTH(1024)
    )DUT(
        .i_Clk(r_Clk),
        .i_Rst(r_Rst),

        .i_RDAddr(r_RDAddr),
        .o_RD(w_RDData),

        .i_WRAddr(r_WRAddr),
        .i_WD(r_WRData),
        .i_WE(r_WR)
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
        
        r_RDAddr <= 1;
        r_WRAddr <= 2;

        r_WRData <= 32'hAAAAAAAA;
        r_WR <= 1'b1;
        @(posedge r_Clk);

        r_RDAddr <= 3;
        r_WRAddr <= 3;
        r_WRData <= 32'h55555555;
        r_WR <= 1'b0;
        @(posedge r_Clk);

        r_WRData <= 32'hFFAADD11;
        r_WR <= 1'b1;
        @(posedge r_Clk);

        r_WR <= 1'b0;
    end
endmodule
