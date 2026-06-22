`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/21 16:24:59
// Design Name: 
// Module Name: address_decoder
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


module address_decoder (
    input wire [31:0] mem_addr,
    input wire        mem_valid,
    output wire       ram_cs,
    output wire       led_en,
    output wire       btn_en,
    output wire       seg_en,
    output wire       tim_en
);
    // 判斷是否存取 I/O 區間 (0x4000_0000 ~ 0x4000_FFFF)
    wire is_io = (mem_addr[31:16] == 16'h4000);

    // I/O 細分周邊
    assign led_en = mem_valid && is_io && (mem_addr[15:0] == 16'h0000); // 0x40000000
    assign btn_en = mem_valid && is_io && (mem_addr[15:0] == 16'h0004); // 0x40000004
    assign seg_en = mem_valid && is_io && (mem_addr[15:0] == 16'h0008); // 0x40000008
    assign tim_en = mem_valid && is_io && (mem_addr[15:0] == 16'h000C); // 0x4000000C

    // 🚀 防呆大招：只要 CPU 發出存取訊號（valid），且「不是存取 I/O」，那就百分之百是在存取 RAM！
    assign ram_cs = mem_valid && !is_io;

endmodule
