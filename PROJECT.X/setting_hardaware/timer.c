#include "setting_hardaware/uart.h"
#include <xc.h>
#include <pic18f4520.h>
#include <stdlib.h>
#include "stdio.h"
#include "string.h"

#define RUNNING 0 
#define STOP 1

int t1=0 , t2=0;
int state = STOP;
void Delay(long int num)
{
    long int j = 0;
    while(j<num)
        j++;
    return;
}
void print()
{
    char word[5] = "";
    sprintf(word , "%d%d" , t1 , t2);
    UART_Write_Text("\b\b");
    UART_Write_Text(word);
}
void __interrupt(low_priority) Low_ISR(void)
{
    if (INTCONbits.INT0IF == 1)
    {
        if(state == STOP)
        {
            t1 = 0;
            t2 = 0;
            T1CONbits.TMR1ON = 1;
            LATD = 0x01;
            state = RUNNING;
        }
        else if(state == RUNNING)
        {
            LATD = 0x00;
            T1CONbits.TMR1ON = 0;
            UART_Write_Text("\r\n");
            UART_Write_Text("Timer: 00");
            TMR1H = 34286 / 256;
            TMR1L = 34286 % 256;
            state = STOP;
        }
        Delay(2000);
        INTCONbits.INT0IF = 0;
    }
    else if(PIR1bits.TMR1IF == 1)
    {
        
        ++t2;
        if(t2 ==10)
        {
            t1++;
            t2 = 0;
        }
        print();
        PIR1bits.TMR1IF = 0;
        TMR1H = 34286 / 256;
        TMR1L = 34286 % 256;
    }

    
}
void main(void) 
{
    
    UART_Initialize();   
    ADCON1bits.PCFG = 0b1110;
    TRISD = 0x00;
    LATD = 0x00;
    T1CON = 0b00100100;
    TRISBbits.RB0 = 1;
    INTCONbits.GIE = 1;
    RCONbits.IPEN = 1;
    PIE1bits.TMR1IE = 1;
    PIR1bits.TMR1IF = 0;
    INTCONbits.INT0IF = 0;
    INTCONbits.INT0IE = 1;
    TMR1H = 34286 / 256;
    TMR1L = 34286 % 256;
    
    UART_Write_Text("\r\n");
    UART_Write_Text("Timer: 00");
    while(1);
    return;
}
