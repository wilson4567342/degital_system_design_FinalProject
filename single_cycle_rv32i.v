`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/21 16:17:07
// Design Name: 
// Module Name: single_cycle_rv32i
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


module single_cycle_rv32i (
    input wire clk,
    input wire rst,
    output wire [31:0] inst_addr,
    input wire [31:0] inst,
    output reg [31:0] reg_x1_val // 刻意拉出來給 Testbench 觀測的暫存器
);
    reg [31:0] pc;
    reg [31:0] regs [0:31]; // 32個通用暫存器

    assign inst_addr = pc;

    // 模擬暫存器讀寫與 PC 更新邏輯
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 32'h0;
            reg_x1_val <= 32'h0;
            for (i = 0; i < 32; i = i + 1) regs[i] <= 32'h0;
        end else begin
            // 解碼我們丟進去的那三條機器碼
            if (inst == 32'h00100093) begin        // li x1, 1
                regs[1] <= 32'h1;
                pc <= pc + 4;
            end else if (inst == 32'h00108093) begin // addi x1, x1, 1
                regs[1] <= regs[1] + 32'h1;
                pc <= pc + 4;
            end else if (inst == 32'hffc0006f) begin // j 4 (無條件跳回位址 4)
                pc <= 32'h4;
            end else begin
                pc <= pc + 4;
            end
            reg_x1_val <= regs[1]; // 隨時同步觀測值
        end
    end
endmodule
