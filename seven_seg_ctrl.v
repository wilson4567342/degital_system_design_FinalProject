`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/21 20:32:03
// Design Name: 
// Module Name: seven_seg_ctrl
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


module seven_seg_ctrl (
    input wire clk,           
    input wire rst,           
    input wire [15:0] data,   
    output reg [3:0] an,      
    output reg [6:0] seg      
);

    reg [19:0] scan_cnt;
    always @(posedge clk) begin
        if (rst) scan_cnt <= 0;
        else     scan_cnt <= scan_cnt + 1;
    end

    reg [3:0] hex_digit;
    always @(*) begin
        case (scan_cnt[19:18])
            2'b00: begin an = 4'b1110; hex_digit = data[3:0];   end // 個位
            2'b01: begin an = 4'b1101; hex_digit = data[7:4];   end // 十位
            2'b10: begin an = 4'b1011; hex_digit = data[11:8];  end // 百位
            2'b11: begin an = 4'b0111; hex_digit = data[15:12]; end // 千位
        endcase
    end

    // 0 是亮，1 是暗。順序為 CA, CB, CC, CD, CE, CF, CG
    always @(*) begin
        case (hex_digit)
            4'h0: seg = 7'b0000001; // 0 (正常了！)
            4'h1: seg = 7'b1001111; // 1
            4'h2: seg = 7'b0010010; // 2
            4'h3: seg = 7'b0000110; // 3
            4'h4: seg = 7'b1001100; // 4
            4'h5: seg = 7'b0100100; // 5
            4'h6: seg = 7'b0100000; // 6
            4'h7: seg = 7'b0001111; // 7
            4'h8: seg = 7'b0000000; // 8
            4'h9: seg = 7'b0000100; // 9
            4'hA: seg = 7'b0001000; // A
            4'hB: seg = 7'b1100000; // b
            4'hC: seg = 7'b0110001; // C
            4'hD: seg = 7'b1000010; // d
            4'hE: seg = 7'b0110000; // E
            4'hF: seg = 7'b0111000; // F
            default: seg = 7'b1111111; // 全滅
        endcase
    end
endmodule
