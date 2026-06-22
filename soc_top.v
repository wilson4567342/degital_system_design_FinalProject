`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/21 16:02:20
// Design Name: 
// Module Name: soc_top
// Description: 
//////////////////////////////////////////////////////////////////////////////////

module soc_top (
    input  wire       clk,        // 100MHz 系統主時脈
    input  wire       btnC,       // 中央按鈕：硬體重置
    input  wire       btnR,       // 最右邊按鈕：玩家反應
    output wire [0:0] LED,        // LED0
    output wire [3:0] an,         // 七段顯示器位選
    output wire [6:0] seg         // 七段顯示器段選
);

    // [1. 時脈分頻器：產生 25MHz 給 CPU 與週邊]
    reg [1:0] clk_div = 2'b00;
    always @(posedge clk) clk_div <= clk_div + 1;
    wire clk_cpu = clk_div[1]; 

    // [2. 自動開機重置：使用 100MHz 驅動]
    reg [7:0] power_on_rst_reg = 8'h00;
    always @(posedge clk) begin 
        if (btnC) power_on_rst_reg <= 8'h00;
        else      power_on_rst_reg <= {power_on_rst_reg[6:0], 1'b1};
    end
    wire resetn = power_on_rst_reg[7];
    wire rst    = ~resetn;

    // [3. 總線訊號宣告]
    wire mem_valid, mem_instr, mem_ready;
    wire [31:0] mem_addr, mem_wdata, mem_rdata;
    wire [3:0]  mem_wstrb;
    
    reg bram_ready, io_ready;
    wire [31:0] bram_rdata, io_rdata;

    assign mem_ready = bram_ready | io_ready;
    assign mem_rdata = bram_ready ? bram_rdata : io_rdata;

    // [4. CPU 核心]
    picorv32 #(.ENABLE_REGS_16_31(1), .COMPRESSED_ISA(0)) cpu_core (
        .clk(clk_cpu), .resetn(resetn), .mem_valid(mem_valid), .mem_instr(mem_instr),
        .mem_ready(mem_ready), .mem_addr(mem_addr), .mem_wdata(mem_wdata),
        .mem_wstrb(mem_wstrb), .mem_rdata(mem_rdata), .trap()
    );

    // [5. 總線時序控制]
    wire bram_sel = mem_valid && (mem_addr[31:16] == 16'h0000 || mem_addr[31:16] == 16'hFFFF);
    wire io_sel   = mem_valid && (mem_addr[31:16] == 16'h4000);

    always @(posedge clk_cpu) begin
        if (rst) begin
            bram_ready <= 1'b0;
            io_ready   <= 1'b0;
        end else begin
            bram_ready <= bram_sel & ~bram_ready;
            io_ready   <= io_sel   & ~io_ready;
        end
    end

    bram_memory my_bram (
        .clk(clk_cpu),
        .addr(mem_addr[15:0]),
        .we(bram_sel ? mem_wstrb : 4'b0000), 
        .wdata(mem_wdata),
        .rdata(bram_rdata)
    );

    // [6. 周邊 I/O 模組]
    wire [31:0] peripheral_seg_data;
    io_peripherals peripherals (
        .clk(clk_cpu), 
        .rst(rst),
        .led_en(io_ready && (mem_addr[3:0] == 4'h0)),
        .btn_en(io_ready && (mem_addr[3:0] == 4'h4)),
        .seg_en(io_ready && (mem_addr[3:0] == 4'h8)),
        .tim_en(io_ready && (mem_addr[3:0] == 4'hC)),
        .mem_wstrb(mem_wstrb), 
        .mem_wdata(mem_wdata), 
        .io_rdata(io_rdata),
        .BTN(btnR), 
        .LED(LED), 
        .seg_data(peripheral_seg_data)
    );
    
    
    // 1. 先定義一個轉換後的 BCD 訊號
    wire [15:0] bcd_output;

    // 2. 轉換模組
    bin_to_bcd converter (
        .bin(peripheral_seg_data[13:0]), // 取出反應時間數值
        .bcd(bcd_output)
    );
    
    // [7. 七段顯示器掃描控制器]
    seven_seg_ctrl seven_seg_unit (
        .clk(clk), 
        .rst(rst), 
        .data(bcd_output), 
        .an(an), 
        .seg(seg)
    );

endmodule