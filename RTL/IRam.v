`timescale 1ns / 1ps

module IRam #(
    parameter MEMORY_WIDTH = 32,
    parameter MEMORY_DEPTH = 1024
    )(
    input i_Clk,
    input i_Rst,

    input [($clog2(MEMORY_DEPTH) * $clog2(MEMORY_WIDTH)) - 1:0] i_Addr,
    output [31:0] o_RD
    );

    assign o_RD = r_RD;
    reg [MEMORY_WIDTH - 1:0] r_RD = 0;

    //Translate the byte addres to a word address
    wire [$clog2(MEMORY_DEPTH) - 1:0] w_Addr = i_Addr[($clog2(MEMORY_DEPTH) * $clog2(MEMORY_WIDTH)) - 1: ($clog2(MEMORY_WIDTH) - 1)/2];
    
    //The Ram block
    reg [MEMORY_WIDTH - 1:0] Ram[MEMORY_DEPTH - 1:0];

    //Initalize the ram
    integer i;
    integer numRamUsed;
    initial begin
Ram[0] = 32'h00002283;
Ram[1] = 32'h10501023;
Ram[2] = 32'h00402583;
Ram[3] = 32'h00800613;
Ram[4] = 32'h018080e7;
Ram[5] = 32'h00000000;
Ram[6] = 32'h00100e13;
Ram[7] = 32'h00000393;
Ram[8] = 32'h00060283;
Ram[9] = 32'h10500223;
Ram[10] = 32'h10002303;
Ram[11] = 32'h01035313;
Ram[12] = 32'hffc31ce3;
Ram[13] = 32'h00138393;
Ram[14] = 32'h00160613;
Ram[15] = 32'hfeb392e3;
Ram[16] = 32'h00008067;
numRamUsed = 17;

        for(i = numRamUsed; i < MEMORY_DEPTH; i = i + 1)begin
            Ram[i] = 0;
        end
    end

    always @(posedge i_Clk) begin
        if(i_Rst)begin
            // for(i = 0; i < MEMORY_DEPTH; i = i + 1)begin
            //     Ram[i] <= 0;
            // end
        end else begin
            r_RD <= Ram[w_Addr];
        end
    end
endmodule
