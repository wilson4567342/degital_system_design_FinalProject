`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/21 16:01:45
// Design Name: 
// Module Name: inst_mem
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


module inst_mem (
    input wire clk,
    input wire [31:0] addr,
    output reg [31:0] rdata
);
    // 宣告一個 64 字長 (words) 的 32-bit 記憶體空間
    reg [31:0] rom [0:63];

    initial begin
        // 邏輯：暫存器 x1 每次加 1，然後無限循環跳回第一條指令
        rom[0] = 32'h00100093; // li x1, 1      (把 1 放進暫存器 x1)
        rom[1] = 32'h00108093; // addi x1, x1, 1 (x1 = x1 + 1)
        rom[2] = 32'hffc0006f; // j 4           (無限跳回 rom[1] 這一行)
        
        // 剩下的記憶體補 0 (NOP 空指令)
        rom[3] = 32'h00000013; 
    end

    // 因為 PicoRV32 的位址是 Byte-addressing，但我們的陣列是 Word-addressing
    // 所以要把位址除以 4 (右移兩位元 addr[31:2]) 來讀取正確的 index
    always @(posedge clk) begin
        rdata <= rom[addr[31:2]];
    end
endmodule
