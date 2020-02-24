`timescale 1ns / 1ps

module SOC_tb();
    reg r_Clk = 0;
    reg r_Rst = 0;

    //Generate the clock and reset signals
    initial begin
        r_Clk = 1'b0;
        r_Rst = 1'b1;
        repeat(4) #10 r_Clk = ~r_Clk;
        r_Rst = 1'b0;
        forever #10 r_Clk = ~r_Clk;
    end

    SOC SOC1(
        .i_Clk(r_Clk),
        .i_Rst(r_Rst)
    );
endmodule
