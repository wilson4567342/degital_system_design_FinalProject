## 1. 專題名稱：基於 RISC-V 之 FPGA 數位反應時間測量系統
## 2. 使用開發板：Basys 3
## 3. 使用工具版本：Vivado 2024.2、RISC-V toolchain：riscv64-unknown-elf-gcc 13.2.0 (Build: gc891d8dc23e)
## 4. 專案資料夾結構
 ├── address_decoder.v      # 位址解碼模組  
 ├── bin_to_bcd.v           # 數值轉換邏輯 (Double Dabble)  
 ├── bram_memory.v          # 區塊記憶體定義  
 ├── inst_mem.v             # 指令記憶體  
 ├── io_peripherals.v       # I/O 周邊控制邏輯  
 ├── riscv_reaction_timer.v # 反應時間測量核心邏輯  
 ├── seven_seg_ctrl.v       # 七段顯示器控制驅動  
 ├── single_cycle_rv32i.v   # RV32I 單週期處理器核心  
 ├── soc_top.v              # 系統頂層模組  
 ├── main.c                 # 系統主程式，負責 MMIO 控制與反應時間演算法  
 ├── main.hex               # 預載入之程式記憶體資料  
 └── dd.xdc                 # Basys 3 FPGA 腳位約束檔  
## 5. 如何產生 bitstream 並燒入至 Basys3 開發板
  5.1 建立與設定專案：開啟 Vivado，點選 Create Project，並將上述所有 .v 原始碼檔案及 .xdc 約束檔匯入專案中。  
  5.2 設定頂層模組：確保 soc_top.v 已被設為專案的頂層模組。    
  5.3 Synthesis：點選 Run Synthesis，等待過程完成，檢查有無語法錯誤。  
  5.4 Implementation：點選 Run Implementation，等待過程完成。  
  5.5 Generate Bitstream：點選 Generate Bitstream，等待過程完成，再點選 Open Hardware Manager 連結 Basys3 板子，最後點選 Program Device 將生成出來的.bit檔案燒錄至板子。
## 6. 如何載入或修改RISC-V程式 
  6.1 修改軟體代碼：修改 main.c 檔案。你可以在此處調整反應時間的測量邏輯、顯示字串或系統參數。  
  6.2 重新編譯程式：使用 RISC-V GCC 工具鏈將 main.c 編譯為執行檔，並轉換為記憶體可用的 .hex 格式。  
  6.3 更新 BRAM 初始化檔案：將新生成的 main.hex 檔案內容，更新至 Vivado 專案所使用的 BRAM 記憶體初始化檔案中。  
  6.4 重新產生 Bitstream： 回到 Vivado 專案介面，重新點選 Generate Bitstream。Vivado 會將最新的 .hex 數據封裝進 FPGA 的 BRAM 區塊中。  
  6.5 燒錄更新：重複「燒錄到 FPGA 開發板」之步驟，將新的 .bit 檔案寫入開發板即可執行更新後的程式。  
## 7. 如何操作與測試  
  7.1 下載至開發板後，按下 Basys3 上的中間按鈕進行重置。  
  7.2 LED[0] 閃爍之後，按下 Basys 3 上的右側按鈕。  
  7.3 七段顯示器會顯示使用者的反應時間。  
## 8. 外部來源與授權說明  
  8.1 PicoRV32 RISC-V Core：https://github.com/YosysHQ/picorv32
