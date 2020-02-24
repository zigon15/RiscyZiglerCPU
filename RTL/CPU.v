`timescale 1ns / 1ps

module CPU#(
    parameter BUS_WORD_ADDR_WIDTH = 16
    )(
    input i_Clk,
    input i_Rst,

    //Simple bus master
    output [BUS_WORD_ADDR_WIDTH - 1:0] o_DBus_Addr,
    input [31:0] i_DBus_RD,
    output o_DBus_WE,
    output [3:0] o_DBus_ByteEn,
    output [31:0] o_DBus_WD
    );

    //--Execution Unit Control Signals--//
    //Program Counter
    wire w_PCWrite;

    //IReg
    wire i_IRegWR;
    wire [31:0] w_Instruction;

    //Register file
    wire w_REGWriteEn;
    wire [1:0] w_REGWriteSrc;

    //ALU
    wire [3:0] w_ALUOpCode;
    wire [1:0] w_ALUSrcASel;
    wire [1:0] w_ALUSrcBSel;
    wire w_ALUZero;

    //--DBus signals--//
    wire w_DBusWE;
    assign o_DBus_WE = w_DBusWE;
    
    wire [2:0] w_BusMode;

    //Bus signal from Execution Unit, byte addressed
    wire [31:0] w_BC_IN_Bus_Addr;
    wire [31:0] w_BC_IN_Bus_RD;
    wire [31:0] w_BC_IN_Bus_WD;

    BusController #(
        .BUS_WORD_ADDR_WIDTH(BUS_WORD_ADDR_WIDTH)
    )BC(
        .i_BusMode(w_BusMode),

        //Bus out
        .o_Out_Addr(o_DBus_Addr),
        .i_Out_RD(i_DBus_RD),
        .o_Out_WD(o_DBus_WD),
        .o_ByteEn(o_DBus_ByteEn),

        //Bus in
        .i_In_Addr(w_BC_IN_Bus_Addr),
        .o_In_RD(w_BC_IN_Bus_RD),
        .i_In_WD(w_BC_IN_Bus_WD)
    );

    CPUExecutionUnit EXEC(
        .i_Clk(i_Clk),
        .i_Rst(i_Rst),
        
        //Control Signals
        //Program Counter
        .i_PCWrite(w_PCWrite),
        
        //IReg
        .i_IRegWR(w_IRegWR),
        .o_Instruction(w_Instruction),

        //Register file
        .i_REGWriteEn(w_REGWriteEn),
        .i_REGWriteSrc(w_REGWriteSrc),

        //ALU
        .i_ALUOpCode(w_ALUOpCode),
        .i_ALUSrcASel(w_ALUSrcASel),
        .i_ALUSrcBSel(w_ALUSrcBSel),
        .o_ALUZero(w_ALUZero),

        //Simple bus master
        .o_Bus_Addr(w_BC_IN_Bus_Addr),
        .i_Bus_RD(w_BC_IN_Bus_RD),
        .o_Bus_WD(w_BC_IN_Bus_WD)
    );
    
    CPUControlUnit CNTRL(
        .i_Clk(i_Clk),
        .i_Rst(i_Rst),

        //Control Signals
        //Program Counter
        .o_PCWrite(w_PCWrite),
        .o_DBusMode(w_BusMode),

        //DRam 
        .o_DBusWE(w_DBusWE),

        //IReg
        .o_IRegWR(w_IRegWR),
        .i_Instruction(w_Instruction),

        //Register file
        .o_REGWriteEn(w_REGWriteEn),
        .o_REGWriteSrc(w_REGWriteSrc),

        //ALU
        .o_ALUOpCode(w_ALUOpCode),
        .o_ALUSrcASel(w_ALUSrcASel),
        .o_ALUSrcBSel(w_ALUSrcBSel),
        .i_ALUZero(w_ALUZero)
    );

endmodule
