`timescale 1ns / 1ps

module CPUControlUnit(
    input i_Clk,
    input i_Rst,
    
    //Control Signals
    //Program Counter
    output reg o_PCWrite,

    //DBus 
    output reg o_DBusWE,
    output reg [2:0] o_DBusMode,

    //IReg
    output reg o_IRegWR,
    input [31:0] i_Instruction,

    //Register file
    output reg o_REGWriteEn,
    output reg [1:0] o_REGWriteSrc,

    //ALU
    output reg [3:0] o_ALUOpCode,
    output reg [1:0] o_ALUSrcASel,
    output reg [1:0] o_ALUSrcBSel,
    input i_ALUZero
    );
    
    initial begin
        o_PCWrite       = 1'b0;
        o_DBusWE        = 1'b0;
        o_DBusMode      = 3'b0;
        o_IRegWR        = 1'b0;
        o_REGWriteEn    = 1'b0;
        o_REGWriteSrc   = 1'b0;
        o_ALUOpCode     = 4'b0;
        o_ALUSrcASel    = 2'b0;
        o_ALUSrcBSel    = 2'b0;
    end

    //Instruction Opcodes 
    parameter p_InstType_R      = 7'b0110011;
    parameter p_InstType_I      = 7'b0010011;
    parameter p_InstType_JALR   = 7'b1100111;
    parameter p_InstType_L      = 7'b0000011;
    parameter p_InstType_LUI    = 7'b0110111;
    parameter p_InstType_AUIPC  = 7'b0010111;
    parameter p_InstType_JAL    = 7'b1101111;
    parameter p_InstType_B      = 7'b1100011;
    parameter p_InstType_S      = 7'b0100011;

    //Register Instruction Functions ({Bit 30, Func3})
    parameter p_InstType_R_ADD  = 4'b0000;
    parameter p_InstType_R_SUB  = 4'b1000;
    parameter p_InstType_R_AND  = 4'b0111;
    parameter p_InstType_R_OR   = 4'b0110;

    //Immediate Instruction Functions (Func3)
    parameter p_InstType_I_ADDI = 3'b000;
    parameter p_InstType_I_ANDI = 3'b111;
    parameter p_InstType_I_ORI  = 3'b110;

    //Load Instruction Functions (Func3)
    parameter p_InstType_L_LB   = 3'b000;
    parameter p_InstType_L_LH   = 3'b001;
    parameter p_InstType_L_LW   = 3'b010;
    parameter p_InstType_L_LBU  = 3'b100;
    parameter p_InstType_L_LHU  = 3'b101;

    //Store Instruction Functions (Func3)
    parameter p_InstType_S_SB   = 3'b000;
    parameter p_InstType_S_SH   = 3'b001;
    parameter p_InstType_S_SW   = 3'b010;

    //Branch Instruction Functions (Func3)
    parameter p_InstType_B_BEQ = 3'b000;
    parameter p_InstType_B_BNE = 3'b001;

    //ALU opcodes
    parameter p_ALU_ADD   = 4'b0000;
    parameter p_ALU_SUB   = 4'b1000;
    parameter p_ALU_AND   = 4'b0111;
    parameter p_ALU_OR    = 4'b0110;
    parameter p_ALU_XOR   = 4'b0100;
    parameter p_ALU_SLL   = 4'b0001;
    parameter p_ALU_SRL   = 4'b0101;
    parameter p_ALU_SRA   = 4'b1101;
    
    //ALU SRC A Mux Options
    parameter p_ALU_SRCA_PREV_PC    = 2'd0;
    parameter p_ALU_SRCA_PC         = 2'd1;
    parameter p_ALU_SRCA_REG_1      = 2'd2;

    //ALU SRC B Mux Options
    parameter p_ALU_SRCB_REG_2    = 2'd0;
    parameter p_ALU_SRCB_CONST_4  = 2'd1;
    parameter p_ALU_SRCB_IMMD     = 2'd2;

    //Register File Write Data Mux Options
    parameter p_REG_WRITE_SRC_PC    = 2'd0; 
    parameter p_REG_WRITE_SRC_DRAM  = 2'd1; 
    parameter p_REG_WRITE_SRC_ALU   = 2'd2;

    //Instruction decode state machine
    localparam INST_STATE_SIZE = 5;
    localparam INST_FETCH           = 0,
               INST_DECODE          = 1,
               INST_REG_WRITE_EN    = 2,
               INST_REG_WRITE_DIS   = 3,
               INST_PC_WRITE_EN     = 4,
               INST_PC_WRITE_DIS    = 5,
               INST_DRAM_WRITE_DIS  = 6,
               INST_JALR_PC_CALC    = 7,
               INST_BRANCH_CHECK    = 8;
    reg [INST_STATE_SIZE-1:0] InstState = INST_FETCH;
    reg [INST_STATE_SIZE-1:0] FSMJumpOnceDone = 0;

    wire [2:0] w_Func3 = i_Instruction[14:12];
    wire [6:0] w_Func7 = i_Instruction[31:25];

    always @(posedge i_Clk) begin
        if(i_Rst)begin
            InstState      <= INST_FETCH;
            o_PCWrite      <= 1'b0;
            o_DBusWE       <= 1'b0;
            o_IRegWR       <= 1'b0;
            o_REGWriteEn   <= 1'b0;
            o_REGWriteSrc  <= 1'b0;
            o_ALUOpCode    <= 4'b0;
            o_ALUSrcASel   <= 2'b0;
            o_ALUSrcBSel   <= 2'b0;
        end else begin
            case (InstState)
                INST_FETCH:begin
                    o_REGWriteEn <= 1'b0;
                    o_DBusWE <= 1'b0;

                    //Load current instruction into the IReg
                    o_IRegWR <= 1'b1;

                    //Calc PC of next seqental instruction
                    o_ALUOpCode <= p_ALU_ADD;
                    o_ALUSrcASel <= p_ALU_SRCA_PC;
                    o_ALUSrcBSel <= p_ALU_SRCB_CONST_4;    
                    o_PCWrite <= 1'b1;
                    
                    InstState <= INST_DECODE;
                end
                INST_DECODE:begin
                    o_IRegWR <= 1'b0;
                    o_PCWrite <= 1'b0;

                    //Opcode decoding
                    case (i_Instruction[6:0])
                        p_InstType_R:begin
                            //I Type, ALU Source is always Reg 1 and Reg 2
                            o_ALUSrcASel <= p_ALU_SRCA_REG_1;
                            o_ALUSrcBSel <= p_ALU_SRCB_REG_2;
                            
                            //ALU result is written back to a register with I type instructions
                            o_REGWriteSrc <= p_REG_WRITE_SRC_ALU;
                            o_REGWriteEn <= 1'b1;
                            
                            InstState <= INST_FETCH;
                            
                            //Work out the correct ALU opcode
                            o_ALUOpCode <= {w_Func7[5], w_Func3};
                        end
                        p_InstType_I:begin
                            //I Type, ALU Source is always Reg 1 and Immediate
                            o_ALUSrcASel <= p_ALU_SRCA_REG_1;
                            o_ALUSrcBSel <= p_ALU_SRCB_IMMD;
                            
                            //ALU result is written back to a register with I type instructions
                            o_REGWriteSrc <= p_REG_WRITE_SRC_ALU;
                            o_REGWriteEn <= 1'b1;

                            InstState <= INST_FETCH;

                            //Work out the correct ALU opcode
                            o_ALUOpCode <= {w_Func7[5], w_Func3};
                        end
                        p_InstType_JALR:begin
                            //SHOULD BE ABLE TO OPTO THIS IS THE DECODE STEP
                            //Current address + 4 is already calculated, write it to the specified reg                            
                            o_REGWriteSrc <= p_REG_WRITE_SRC_PC; 
                            o_REGWriteEn <= 1'b1;

                            InstState <= INST_JALR_PC_CALC;
                        end
                        p_InstType_L:begin
                            //Calculate the address in ram to load the data from
                            o_ALUOpCode <= p_ALU_ADD;
                            o_ALUSrcASel <= p_ALU_SRCA_REG_1;
                            o_ALUSrcBSel <= p_ALU_SRCB_IMMD; 

                            o_REGWriteSrc <= p_REG_WRITE_SRC_DRAM;
                            o_DBusMode <= w_Func3;

                            InstState <= INST_REG_WRITE_EN;
                            FSMJumpOnceDone <= INST_FETCH; 

                        end
                        p_InstType_LUI:begin
                            
                        end
                        p_InstType_AUIPC:begin
                            
                        end
                        p_InstType_JAL:begin
                            
                        end
                        p_InstType_B:begin
                            //Check if a branch should take place
                            o_ALUOpCode <= p_ALU_SUB;
                            o_ALUSrcASel <= p_ALU_SRCA_REG_1;
                            o_ALUSrcBSel <= p_ALU_SRCB_REG_2;

                            InstState <= INST_BRANCH_CHECK;
                        end
                        p_InstType_S:begin
                            //Calculate the address in ram to store the data to
                            o_ALUOpCode <= p_ALU_ADD;
                            o_ALUSrcASel <= p_ALU_SRCA_REG_1;
                            o_ALUSrcBSel <= p_ALU_SRCB_IMMD;

                            o_DBusWE <= 1'b1;
                            o_DBusMode <= w_Func3;
                            
                            InstState <= INST_FETCH;
                        end
                        default:begin
                            
                        end
                    endcase
                end
                INST_REG_WRITE_EN:begin
                    o_REGWriteEn <= 1'b1;
                    InstState <= INST_REG_WRITE_DIS;
                end
                INST_REG_WRITE_DIS:begin
                    o_REGWriteEn <= 1'b0;
                    InstState <= FSMJumpOnceDone;
                end
                INST_PC_WRITE_DIS:begin
                    o_PCWrite <= 1'b0;
                    InstState <= FSMJumpOnceDone;
                end
                INST_DRAM_WRITE_DIS:begin
                    o_DBusWE <= 1'b0;
                    InstState <= FSMJumpOnceDone;
                end
                INST_JALR_PC_CALC:begin
                    o_REGWriteEn <= 1'b0;

                    //Calculate the address to jump to and then jump to it
                    o_ALUOpCode <= p_ALU_ADD;
                    o_ALUSrcASel <= p_ALU_SRCA_REG_1;
                    o_ALUSrcBSel <= p_ALU_SRCB_IMMD; 
                    o_PCWrite <= 1'b1;

                    FSMJumpOnceDone <= INST_FETCH;
                    InstState <= INST_PC_WRITE_DIS;
                end
                INST_BRANCH_CHECK:begin
                    if(i_ALUZero ^ w_Func3[0])begin
                        //Calculate what the branch address is
                        o_ALUOpCode <= p_ALU_ADD;
                        o_ALUSrcASel <= p_ALU_SRCA_PREV_PC;
                        o_ALUSrcBSel <= p_ALU_SRCB_IMMD;
                        o_PCWrite <= 1'b1;

                        FSMJumpOnceDone <= INST_FETCH;
                        InstState <= INST_PC_WRITE_DIS;
                    end else begin
                        InstState <= INST_FETCH;
                    end
                end
            endcase
        end
    end
endmodule
