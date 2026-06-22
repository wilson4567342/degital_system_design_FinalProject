`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/21 16:41:33
// Design Name: 
// Module Name: bram_memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bram_memory (
    input wire clk,
    input wire [15:0] addr, 
    input wire [3:0]  we,   
    input wire [31:0] wdata,
    output reg [31:0] rdata
);

    reg [31:0] mem [0:16383];

    // 載入 HEX 檔案
    initial begin
        $readmemh("main.hex", mem);
    end

    // 同步讀寫
    always @(posedge clk) begin
        // 寫入邏輯
        if (we[0]) mem[addr[15:2]][7:0]   <= wdata[7:0];
        if (we[1]) mem[addr[15:2]][15:8]  <= wdata[15:8];
        if (we[2]) mem[addr[15:2]][23:16] <= wdata[23:16];
        if (we[3]) mem[addr[15:2]][31:24] <= wdata[31:24];
        
        rdata <= mem[addr[15:2]]; 
    end

endmodule
