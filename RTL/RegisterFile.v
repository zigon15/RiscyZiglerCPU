`timescale 1ns / 1ps

module RegisterFile#(
    parameter REG_WIDTH = 32,
    parameter REG_DEPTH = 32
    )(
    input i_Clk,
    input i_Rst,

    input [$clog2(REG_WIDTH) - 1:0] i_Addr1,
    input [$clog2(REG_WIDTH) - 1:0] i_Addr2,
    input [$clog2(REG_WIDTH) - 1:0] i_Addr3,

    output [REG_WIDTH - 1:0] o_RD1,
    output [REG_WIDTH - 1:0] o_RD2,
    
    input i_WE,
    input [1:0] i_WDSrc,
    input [REG_WIDTH - 1:0] i_WD0,
    input [REG_WIDTH - 1:0] i_WD1,
    input [REG_WIDTH - 1:0] i_WD2
    );

    assign o_RD1 = r_RD1;
    assign o_RD2 = r_RD2;
    reg [REG_WIDTH - 1:0] r_RD1 = 0;
    reg [REG_WIDTH - 1:0] r_RD2 = 0;

    //The registers, the first register is hard coded to 0
    reg [REG_WIDTH - 1:0] Registers[REG_DEPTH - 1:0];

    wire [REG_WIDTH - 1:0] w_Inputs [2:0] = {i_WD2, i_WD1, i_WD0};

    //Initalize the registers to 0 on startup
    integer i;
    initial begin
        for(i = 0; i < REG_DEPTH; i = i + 1)begin
            Registers[i] = 0;
        end
    end

    always @(posedge i_Clk) begin
        if(i_Rst)begin
            for(i = 0; i < REG_DEPTH; i = i + 1)begin
                Registers[i] <= 32'h0;
            end
        end else begin
            r_RD1 <= (i_Addr1 == 32'b0)? 32'b0: Registers[i_Addr1];
            r_RD2 <= (i_Addr2 == 32'b0)? 32'b0: Registers[i_Addr2];

            if(i_WE)begin
                if(i_Addr3 != 0)begin
                    Registers[i_Addr3] <= w_Inputs[i_WDSrc]; 
                end
            end
        end

    end
endmodule
