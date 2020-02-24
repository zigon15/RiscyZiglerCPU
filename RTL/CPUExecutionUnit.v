`timescale 1ns / 1ps

module CPUExecutionUnit(
    input i_Clk,
    input i_Rst,

    //Control Signals
    //Program Counter
    input i_PCWrite,

    //IReg
    input i_IRegWR,
    output [31:0] o_Instruction,

    //Register file
    input i_REGWriteEn,
    input [1:0] i_REGWriteSrc,

    //ALU
    input [3:0] i_ALUOpCode,
    input [1:0] i_ALUSrcASel,
    input [1:0] i_ALUSrcBSel,
    output o_ALUZero,

    //Simple bus master
    output [31:0] o_Bus_Addr,
    input [31:0] i_Bus_RD,
    output [31:0] o_Bus_WD
    );
    
    assign o_Bus_Addr = w_ALUResult;
    assign o_Bus_WD = w_RD2;

    //PC signals
    wire [31:0] w_PC;
    wire [31:0] w_PrevPC;

    //IRam signals
    wire [31:0] w_IRd;

    //IReg signal
    wire [31:0] w_Instruction;
    assign o_Instruction = w_Instruction;

    //RegFile signals
    wire [31:0] w_RD1;
    wire [31:0] w_RD2;

    //ALU signals
    wire [31:0] w_ALUResult;
    wire w_ALUZero;
    assign o_ALUZero = w_ALUZero;
    
    //Signed extended immediate
    wire [31:0] w_Immediate;

    //Program Counter
    ProgramCounter #(
        .INITAL_PC_VALUE(0)
    )PC(
        .i_Clk(i_Clk),
        .i_Rst(i_Rst),
        
        .o_PC(w_PC),
        .o_PrevPC(w_PrevPC),
        .i_EN(i_PCWrite),
        .i_NewPC(w_ALUResult)
    );

    //Instruction Ram
    IRam #(
        .MEMORY_WIDTH(32),
        .MEMORY_DEPTH(32)
    )IRAM(
        .i_Clk(i_Clk),
        .i_Rst(i_Rst),

        .i_Addr(w_PC),
        .o_RD(w_IRd)
    );

    //Instruction Register
    InstructionReg IREG(
        .i_Clk(i_Clk),
        .i_Rst(i_Rst),
        .i_Wr(i_IRegWR),
        .i_Data(w_IRd),
        .o_Instruction(w_Instruction)
    );

    //Register File
    RegisterFile #(
        .REG_WIDTH(32),
        .REG_DEPTH(32)
    )REGFILE(
        .i_Clk(i_Clk),
        .i_Rst(i_Rst),

        .i_Addr1(w_Instruction[19:15]),
        .i_Addr2(w_Instruction[24:20]),
        .i_Addr3(w_Instruction[11:7]),

        .o_RD1(w_RD1),
        .o_RD2(w_RD2),

        .i_WE(i_REGWriteEn),
        .i_WDSrc(i_REGWriteSrc),
        .i_WD0(w_PC),
        .i_WD1(i_Bus_RD),
        .i_WD2(w_ALUResult)
    );

    ImmediateGen IMMGEN(
        .i_OpCode(w_Instruction[6:0]),
        .i_Inst(w_Instruction),
        .o_Immediate(w_Immediate)
    );

    //Main ALU
    ALU ALU1(
        .i_OpCode(i_ALUOpCode),

        .i_SrcASel(i_ALUSrcASel),
        .i_SrcA0(w_PrevPC),
        .i_SrcA1(w_PC),
        .i_SrcA2(w_RD1),

        .i_SrcBSel(i_ALUSrcBSel),
        .i_SrcB0(w_RD2),
        .i_SrcB1(32'd4),
        .i_SrcB2(w_Immediate),
        .i_SrcB3(32'd0),

        .o_Result(w_ALUResult),
        .o_Zero(w_ALUZero)
    );

endmodule
