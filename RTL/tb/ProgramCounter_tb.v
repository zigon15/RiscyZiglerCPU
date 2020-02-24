`timescale 1ns / 1ps

module ProgramCounter_tb();

    reg r_Clk = 0;
    reg r_Rst = 0;
    
    wire [31:0] w_PC;
    reg r_EN = 0;
    reg [31:0] r_NewPC = 0;

    //Device under test
    ProgramCounter #(
        .INITAL_PC_VALUE(32'hFF)
    ) DUT(
        .i_Clk(r_Clk),
        .i_Rst(r_Rst),
        .o_PC(w_PC),
        .i_EN(r_EN),
        .i_NewPC(r_NewPC)
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
        
        r_NewPC = w_PC + 4;
        r_EN = 1'b1;
        @(posedge r_Clk);

        r_NewPC = 32'h04;
        @(posedge r_Clk);

        r_EN = 1'b0;
        r_NewPC = 32'hAA;
        @(posedge r_Clk);

        $finish;
    end

endmodule
