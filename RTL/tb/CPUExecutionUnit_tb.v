`timescale 1ns / 1ps

module CPUExecutionUnit_tb();
    //The various ALU operations
    parameter ALU_ADDITION      = 2'b00;
    parameter ALU_SUBTRACTION   = 2'b01;
    parameter ALU_AND           = 2'b10;
    parameter ALU_OR            = 2'b11;

    //ALU SRC A Mux Options
    parameter ALU_SRCA_REG_1    = 1'd0;
    parameter ALU_SRCA_PC       = 1'd1;

    //ALU SRC B Mux Options
    parameter ALU_SRCB_REG_2    = 2'd0;
    parameter ALU_SRCB_CONST_1  = 2'd1;
    parameter ALU_SRCB_IMMD     = 2'd2;

    //IDRam Address Mux Options
    parameter IDRAM_SEL_ADDR_I = 1'b1;
    parameter IDRAM_SEL_ADDR_D = 1'b0;

    //Various instruction types
    parameter INST_TYPE_B = 0;
    parameter INST_TYPE_S = 1;
    parameter INST_TYPE_I = 2;
    parameter INST_TYPE_J = 3;
    parameter INST_TYPE_U = 4;

    reg r_Clk = 0;
    reg r_Rst = 0;

    //Program Counter
    reg r_PCWrite = 0;

    //Instruction Reg
    reg r_IRegWrite = 0;
    wire [31:0] w_Instruction;

    //Register file
    reg r_REGWriteEN = 0;

    //IDRam
    reg r_IDAddrSel = 0;
    reg r_IDMemWrite = 0;

    //ImmediateGen
    reg [2:0] r_InstType = 0;

    //ALU
    reg [1:0] r_ALUOpCode = 0;
    reg r_ALUSrcASel = 0;
    reg [1:0] r_ALUSrcBSel = 0;

    CPUExecutionUnit EXEC(
        .i_Clk(r_Clk),
        .i_Rst(r_Rst),
        
        //Control Signals
        //Program Counter
        .i_PCWrite(r_PCWrite),

        //Instruction Reg
        .r_IRegWrite(r_IRegWrite),
        .o_Instruction(w_Instruction),
        
        //Register file
        .i_REGWriteEn(r_REGWriteEN),

        //IDRam 
        .i_IDAddrSel(r_IDAddrSel),
        .i_IDMemWrite(r_IDMemWrite),

        //ImmediateGen
        .i_InstType(r_InstType),

        //ALU
        .i_ALUOpCode(r_ALUOpCode),
        .i_ALUSrcASel(r_ALUSrcASel),
        .i_ALUSrcBSel(r_ALUSrcBSel)
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
        //Wait for reset
        @(negedge r_Rst);
        @(posedge r_Clk);

        //Fetch Instruction
        r_IDAddrSel <= IDRAM_SEL_ADDR_I;
        
        //Increase PC to next instruction ready for next fetch cycle
        r_ALUOpCode <= ALU_ADDITION;
        r_ALUSrcASel <= ALU_SRCA_PC;
        r_ALUSrcBSel <= ALU_SRCB_CONST_1;
        
        r_PCWrite <= 1'b1;
        r_IRegWrite <= 1'b1;
        
        //Simulate the decode step
        @(posedge r_Clk);
        //Clean up after last step, new instruction should now be fetched
        r_IRegWrite <= 1'b0;
        r_PCWrite <= 1'b0;
        
        @(posedge r_Clk);

        //Calculate the address in ram to load the data from and put it into a reg
        r_ALUOpCode <= ALU_ADDITION;
        r_ALUSrcASel <= ALU_SRCA_REG_1;
        r_ALUSrcBSel <= ALU_SRCB_IMMD; 
        r_IDAddrSel <= IDRAM_SEL_ADDR_D;

        //Set the Instruction type so that the immediate can be generated
        r_InstType <= INST_TYPE_I;
       
        @(posedge r_Clk);
        //The address should be at the IDRam now so write the data to the correct reg
        r_REGWriteEN <= 1'b1;

        @(posedge r_Clk);
        r_REGWriteEN <= 1'b0;
    end

endmodule
