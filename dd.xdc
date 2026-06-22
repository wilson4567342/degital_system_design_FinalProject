## 1. 時脈訊號 (Clock Signal - 100MHz)
set_property PACKAGE_PIN W5 [get_ports clk]							
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## 2. 重置訊號 (Reset - 使用板子中央的 btnC 按鈕)
set_property PACKAGE_PIN U18 [get_ports btnC]						
set_property IOSTANDARD LVCMOS33 [get_ports btnC]

## 3. LED 指示燈 (LED[0] - 使用最右邊的 LD0)
set_property PACKAGE_PIN U16 [get_ports {LED[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]

## 4. 玩家按鈕 (BTN - 使用最右邊的實體按鈕 btnR)
set_property PACKAGE_PIN T17 [get_ports btnR]						
set_property IOSTANDARD LVCMOS33 [get_ports btnR]

## 5. 七段顯示器數據 (seg_data - 假設對應到板子上的七段顯示器)
set_property PACKAGE_PIN U7 [get_ports {seg[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN V5 [get_ports {seg[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U5 [get_ports {seg[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U8 [get_ports {seg[4]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN W6 [get_ports {seg[5]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN W7 [get_ports {seg[6]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

## 6. 七段顯示器 4 位數致能腳位 (AN0, AN1, AN2, AN3)
set_property PACKAGE_PIN U2 [get_ports {an[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]