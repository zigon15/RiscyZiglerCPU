#include "stdint.h"

#define ADDR_UART_BIT_PER_CLK (uint32_t*)256
#define ADDR_UART_CTRL        (uint32_t*)258
#define ADDR_UART_DATA        (uint32_t*)260

int bitPerCLk = 2;
int strLen = 14;
char str[] = "Hello world\r\n";

void main(){
    *ADDR_UART_BIT_PER_CLK = bitPerCLk;

    for(int i = 0; i < strLen; i++){
        *ADDR_UART_DATA = str[i];
        while(*ADDR_UART_CTRL);
    }
}