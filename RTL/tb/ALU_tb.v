`timescale 1ns / 1ps

module ALU_tb();
    reg r_Clk = 0;
    reg r_Rst = 0;

    //The various ALU operations
    parameter ALU_ADDITION      = 2'b00;
    parameter ALU_SUBTRACTION   = 2'b01;
    parameter ALU_AND           = 2'b10;
    parameter ALU_OR            = 2'b11;

    reg [1:0] w_Op = 0;

    reg [31:0] w_SrcA0 = 0;
    reg [31:0] w_SrcB0 = 0;
    
    reg r_SrcASel = 1'b0;
    reg [1:0] r_SrcBSel = 2'b0;

    wire [31:0] w_Result;
    wire w_Zero;

    //Device under test
    ALU DUT(
        .i_Clk(r_Clk),
        .i_Rst(r_Rst),

        .i_OpCode(w_Op),

        .i_SrcASel(r_SrcASel),
        .i_SrcA0(w_SrcA0),
        .i_SrcA1(32'd1),

        .i_SrcBSel(r_SrcBSel),
        .i_SrcB0(w_SrcB0),
        .i_SrcB1(-32'd1),
        .i_SrcB2(32'd0),
        .i_SrcB3(32'd0),

        .o_Result(w_Result),
        .o_Zero(w_Zero)
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
        

        //Select the register inputs, do positive op
        r_SrcASel = 1'b0;
        r_SrcBSel = 2'b0;
        w_SrcA0 = 10;
        w_SrcB0 = 12;
        w_Op = ALU_ADDITION;
        @(posedge r_Clk);


        //Select the constant input for srcA and reg input for srcB
        r_SrcASel = 1'b1;
        r_SrcBSel = 2'b0;
        w_SrcB0 = 12;
        w_Op = ALU_SUBTRACTION;
        @(posedge r_Clk);


        @(posedge r_Clk);

    end
endmodule
