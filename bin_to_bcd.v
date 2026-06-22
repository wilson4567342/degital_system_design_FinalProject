`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/22 10:15:18
// Design Name: 
// Module Name: bin_to_bcd
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


module bin_to_bcd (
    input  [13:0] bin,    // 假設你的反應時間最大不超過 9999ms
    output reg [15:0] bcd // 輸出 4 位十進位 (BCD 碼)
);
    integer i;
    always @(*) begin
        bcd = 0;
        for (i = 0; i < 14; i = i + 1) begin
            // 如果 BCD 的每一位 >= 5，則加 3 (為了跳進位)
            if (bcd[3:0]   >= 5) bcd[3:0]   = bcd[3:0]   + 3;
            if (bcd[7:4]   >= 5) bcd[7:4]   = bcd[7:4]   + 3;
            if (bcd[11:8]  >= 5) bcd[11:8]  = bcd[11:8]  + 3;
            if (bcd[15:12] >= 5) bcd[15:12] = bcd[15:12] + 3;
            
            // 左移一位，將 bin 的值補進來
            bcd = {bcd[14:0], bin[13-i]};
        end
    end
endmodule
