#pragma config OSC = INTIO67      // Oscillator Selection bits (HS oscillator)
#pragma config FCMEN = OFF      // Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
#pragma config IESO = ON       // Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)
#pragma config PWRT = OFF       // Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = SBORDIS  // Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
#pragma config BORV = 3         // Brown Out Reset Voltage bits (Minimum setting)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 1        // Watchdog Timer Postscale Select bits (1:1)
#pragma config CCP2MX = PORTC   // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = ON      // PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
#pragma config LPT1OSC = OFF    // Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config STVREN = ON      // Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
#pragma config LVP = OFF         // Single-Supply ICSP Enable bit (Single-Supply ICSP enabled)
#pragma config XINST = OFF      // Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))
#pragma config CP0 = OFF        // Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
#pragma config CP1 = OFF        // Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
#pragma config CP2 = OFF        // Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
#pragma config CP3 = OFF        // Code Protection bit (Block 3 (006000-007FFFh) not code-protected)
#pragma config CPB = OFF        // Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
#pragma config CPD = OFF        // Data EEPROM Code Protection bit (Data EEPROM not code-protected)
#pragma config WRT0 = OFF       // Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
#pragma config WRT1 = OFF       // Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
#pragma config WRT2 = OFF       // Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
#pragma config WRT3 = OFF       // Write Protection bit (Block 3 (006000-007FFFh) not write-protected)
#pragma config WRTC = OFF       // Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
#pragma config WRTB = OFF       // Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
#pragma config WRTD = OFF       // Data EEPROM Write Protection bit (Data EEPROM not write-protected)
#pragma config EBTR0 = OFF      // Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR1 = OFF      // Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR2 = OFF      // Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR3 = OFF      // Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)
#pragma config EBTRB = OFF      // Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

#include <stdlib.h>
#include <pic18f4520.h>
#include "setting_hardaware/uart.h"
#include <stdio.h>
#include <string.h>

char str[20];

void Mode1()
{
    ClearBuffer();
    UART_Write_Text("enter mode 1\n"); // TODO
    return ;
}

void delay(int num)
{
    int i = 0;
    while(i<num)
        i++;
    return;
}

void Mode2()
{
    ClearBuffer();
    UART_Write_Text("enter mode 2\n");
    long long int last_value = 0;
    
    while(1)
    {
        PIR1bits.ADIF = 0;
        ADCON0bits.GO = 1; //after conversion flag bit = 1
        delay(100);
        if(RCIF == 1)
        {
            RCIF = 0;
            unsigned char c = RCREG;
            if(c == 'e')
            {
                UART_Write(c);
                UART_Write('\n');                
                ADCON0bits.GO = 0;
                return;
            }
        }
        char output[5];
        long long int value_H = ADRESH;
        long long int value_L = ADRESL;
        long long int value_int = value_H * 256 + value_L;

        if( abs(value_int - last_value) > 5)
        {
            last_value = value_int;
            
            float value_float = (float)value_int * (float)500;
            value_float = value_float / 1023;
            value_int = (long long int)value_float;

            value_float = (float)value_int / (float)100;
            sprintf(output,"%.2f",value_float);
            output[4] = ' ';
            UART_Write_Text(output);   
        }
    }

    return ;
}

void main(void) 
{
    UART_Initialize();
    VR_Initialize();
    while(1)
    {
        ClearBuffer();
        strcpy(str , GetString() );
        if(str[0]=='m' && str[1]=='o' && str[2] == 'd' && str[3] == 'e' && str[4] == '1')
        {
            Mode1();
            ClearBuffer();
        }
        else if(str[0]=='m' && str[1]=='o' && str[2] == 'd' && str[3] == 'e' && str[4] == '2')
        {
            Mode2();
            ClearBuffer();
        }
    }
    return;
}

void __interrupt(high_priority) Hi_ISR(void)
{
    
}