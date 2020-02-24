#Uart Pherip
.equ ADDR_UART_CTRL,    256
.equ ADDR_UART_DATA, 	260

.equ ADDR_UART_IDLE_BIT,    16

.section .text
.global _start      # Provide program starting address to linker
_start:
    #Load and store the UART clocks/bit value
    lw t0, %lo(BITS_PER_CLK)(zero)
    sh t0, ADDR_UART_CTRL(zero)

    #Load the string length and initalize the string pointer
    lw a1, %lo(STRING_LEN)(zero)
    addi a2, zero, %lo(STRING_1)

    jalr %lo(UartWriteString)(ra)

.4byte 0x0

#a1 contain string length, a2 contains string pointer
UartWriteString:
    #Used to compare Bit0 in the UART ctrl reg
    addi t3, zero, 1

    #Initiate the loop counter to 0
    addi t2, zero, 0;

    UartWriteString_L1:
        #Load the character pointed to by the string pointer and write it to UART
        lb t0, 0(a2)
        sb t0, ADDR_UART_DATA(zero)

        #Wait for the UART TX module to be idle
        UartWaitTillIdle:
            lw t1, ADDR_UART_CTRL(zero)
            srli t1, t1, ADDR_UART_IDLE_BIT
            bne t1, t3, UartWaitTillIdle
        
        #Increment the loop counter and string pointer
        addi t2, t2, 1
        addi a2, a2, 1

        bne t2, a1, UartWriteString_L1
    ret
    
.section .data
BITS_PER_CLK:   .4byte 2
STRING_LEN:     .4byte 14
STRING_1:       .string "Hello World\r\n"
STRING_2:       .string "String2"
