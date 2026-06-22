void _start() __attribute__((naked));
void _start() {
    // 將 Stack Pointer (sp) 初始化到 BRAM 的頂端 (64KB = 0x00010000)
    asm volatile("lui sp, 0x10");
    asm volatile("j main");
}

// =================================================================
// 1. 定義 Memory-mapped I/O 暫存器位址
// =================================================================
#define REG_LED  (*(volatile unsigned int *)0x40000000)
#define REG_BTN  (*(volatile unsigned int *)0x40000004)
#define REG_SEG  (*(volatile unsigned int *)0x40000008)
#define REG_TIM  (*(volatile unsigned int *)0x4000000C)

// 簡易隨機數產生器
unsigned int rand_state = 1120345; 
unsigned int get_random_delay() {
    rand_state = rand_state * 1103515245 + 12345;
    return (rand_state & 0x7FF) + 1000; 
}

// 延遲函式
void delay_ms(unsigned int ms) {
    unsigned int start = REG_TIM;
    while ((REG_TIM - start) < ms);
}

// =================================================================
// 2. 主程式邏輯
// =================================================================
int main() {
    unsigned int random_wait_time = get_random_delay();
    
    // 1. 等待隨機時間 (此時 LED 暗，七段顯示 0000)
    delay_ms(random_wait_time);
    
    // 2. 點亮 LED 燈
    REG_LED = 1;
    
    // 3. 記錄當下時間
    unsigned int t_start = REG_TIM;
    
    // 4. 等待玩家按下按鈕
    while (REG_BTN == 0);
    
    // 5. 玩家按下了，記錄結束時間
    unsigned int t_end = REG_TIM;
    
    // 6. 計算反應時間並寫入七段顯示器
    unsigned int response_time = t_end - t_start;
    REG_SEG = response_time;
    
    // 7. 熄滅 LED，結束進入死迴圈
    REG_LED = 0;
    while(1);
    
    return 0;
}
