`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/21 16:26:07
// Design Name: 
// Module Name: io_peripherals
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


module io_peripherals (
    input wire clk,
    input wire rst,
    
    // 來自 Address Decoder 的各周邊致能訊號 (Active High)
    input wire led_en,
    input wire btn_en,
    input wire seg_en,
    input wire tim_en,
    
    // 來自 CPU Bus 的寫入控制與數據
    input wire [3:0]  mem_wstrb,
    input wire [31:0] mem_wdata,
    
    // 輸出給 CPU Bus 的讀取數據
    output wire [31:0] io_rdata,
    
    // 實體硬體腳位 / Testbench 連線訊號
    output reg  [0:0]  LED,
    input wire         BTN,
    output reg  [31:0] seg_data
);

    // -----------------------------------------------------------------
    // 1. 內部暫存器宣告
    // -----------------------------------------------------------------
    reg [31:0] timer_reg;   // 記錄當前時間（單位：毫秒）的暫存器 (0x4000000C)
    reg [19:0] clk_cnt;     // 模擬專用精簡計數器，用來分頻產生 1ms 訊號

    // -----------------------------------------------------------------
    // 2. 周邊寫入邏輯：處理 CPU 寫入 LED 與 七段顯示器
    // -----------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            LED      <= 1'b0;
            seg_data <= 32'd0;
        end else begin
            // CPU 寫入 LED 暫存器 (位址: 0x40000000)
            if (led_en && mem_wstrb[0]) begin
                LED[0] <= mem_wdata[0];
            end
            
            // CPU 寫入 七段顯示器暫存器 (位址: 0x40000008)
            if (seg_en) begin
                if (mem_wstrb[0]) seg_data[7:0]   <= mem_wdata[7:0];
                if (mem_wstrb[1]) seg_data[15:8]  <= mem_wdata[15:8];
                if (mem_wstrb[2]) seg_data[23:16] <= mem_wdata[23:16];
                if (mem_wstrb[3]) seg_data[31:24] <= mem_wdata[31:24];
            end
        end
    end

    // -----------------------------------------------------------------
    // 3. 硬體計時器 (Timer) 邏輯：兼顧模擬速度與精準度
    // -----------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            clk_cnt   <= 20'd0;
            timer_reg <= 32'd0;
        end else begin
            // 🚀 恢復真實世界計時：在 25MHz 時脈下，數 25000 次剛好是 1 毫秒 (1ms)
            if (clk_cnt == 20'd24999) begin
                clk_cnt   <= 20'd0;
                timer_reg <= timer_reg + 1'b1;
            end else begin
                clk_cnt <= clk_cnt + 1'b1;
            end
        end
    end

    // -----------------------------------------------------------------
    // 4. 周邊讀取邏輯：根據 Decoder 訊號，把對應周邊的數值餵回給 CPU
    // -----------------------------------------------------------------
    assign io_rdata = (led_en) ? {31'd0, LED} :  // 讀取 LED 狀態 (0x40000000)
                      (btn_en) ? {31'd0, BTN} :  // 讀取按鈕狀態 (0x40000004)
                      (seg_en) ? seg_data     :  // 讀取七段顯示器當前數值 (0x40000008)
                      (tim_en) ? timer_reg    :  // 讀取當前時間暫存器 (0x4000000C)
                      32'd0;                     // 預設回傳 0

endmodule
