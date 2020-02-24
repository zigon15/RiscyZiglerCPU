`timescale 1ns / 1ps

module DRam #(
    parameter ADDR_WIDTH = 16,
    parameter ADDR_BITS_PER_CHUCK = 6,
    parameter ADDR_BLOCK = 0,
    parameter MEMORY_DEPTH = 64
    )(
    input i_Clk,
    input i_Rst,

    input [ADDR_WIDTH-1:0] i_Addr,
    output [31:0] o_RD,
    input i_WE,
    input [3:0] i_ByteEn,
    input [31:0] i_WD
    );
    
    wire w_Sel = (i_Addr[ADDR_WIDTH-1 :ADDR_BITS_PER_CHUCK] == ADDR_BLOCK)? 1: 0;
    wire [ADDR_BITS_PER_CHUCK-1:0] w_Addr = i_Addr[ADDR_BITS_PER_CHUCK-1:0];

    assign o_RD = w_Sel? r_RD : 32'bz;

    reg [31:0] r_RD = 0;

    //The Ram block
    reg [31:0] Ram [MEMORY_DEPTH - 1:0];

    //Initalize the ram
    integer i;
    integer numRamUsed;
    initial begin
        //Ram[0]  = 868;
Ram[0] = 32'h00000002;
Ram[1] = 32'h0000000e;
Ram[2] = 32'h6c6c6548;
Ram[3] = 32'h6f57206f;
Ram[4] = 32'h0d646c72;
Ram[5] = 32'h7453000a;
Ram[6] = 32'h676e6972;
numRamUsed = 7;

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
            if(w_Sel)begin
                r_RD <= Ram[w_Addr];

                if(i_WE)begin
                    Ram[w_Addr][7:0]    <= i_ByteEn[0]? i_WD[7:0]   : Ram[w_Addr][7:0];
                    Ram[w_Addr][15:8]   <= i_ByteEn[1]? i_WD[15:8]  : Ram[w_Addr][15:8];
                    Ram[w_Addr][23:1]   <= i_ByteEn[2]? i_WD[23:1]  : Ram[w_Addr][23:1];
                    Ram[w_Addr][31:24]  <= i_ByteEn[3]? i_WD[31:24] : Ram[w_Addr][31:24];
                end
            end
        end
    end
endmodule
