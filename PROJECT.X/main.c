#include "setting_hardaware/uart.h"
#include <xc.h>
#include <pic18f4520.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#define _XTAL_FREQ 500000

void PWM_setup();
void interrupt_setup();
void _1_second();
void get_input();
void wait_button();
void print_current_time();
void ADC_setup();
int get_volume();
void delay();

time_t epoch_time;
char str[20];
struct tm* TM;
int state = 0;
int volume_count = 0;

void __interrupt(high_priority) Hi_ISR(void)
{
    if(INTCONbits.INT0IF == 1)
    {
        INTCONbits.INT0IE = 0;
        state++;
        state %= 3;
        INTCONbits.INT0IF = 0;
        
        if(state == 0)
        {
            LATD = 0b00000001;
            UART_Write_Text("NONE\r\n");
        }
        else if(state == 1)
        {
            LATD = 0b00000011;            
        }
        else if(state == 2)
        {
            LATD = 0b00000111;
        }
        delay(10);
        INTCONbits.INT0IE = 1;
    }
    return;
}

void main(void) 
{
    PWM_setup();
    ADC_setup();
    interrupt_setup();
    UART_Initialize();
    TRISBbits.RB0 = 1;
    TRISD = 0x00;
    LATD = 0x00;
    UART_Write(0x0C);

    wait_button();
    get_input();
    
    while(1) 
    {   
        _1_second();
        epoch_time++;
        if(state == 0)
        {
            volume_count = 0;
        }
        else if(state == 1)
        {
            print_current_time();
            volume_count = 0;
        }
        else if(state == 2) // ADC conveerter
        {
            int last_volume = 0 , counter = 0;
            if(volume_count == 0)
            {
                UART_Write_Text("VOLUME\r\n");
            }
            volume_count++;
            ADCON0bits.GO = 1;
            while(PIR1bits.ADIF == 0)
            {
                ;
            }
            PIR1bits.ADIF = 0;
            int v= get_volume();
            char output[15];

//            if( abs(volume - last_volume)>3 )
//            {
//            last_volume = volume;
            int valueH = ADRESH ;
            int valueL = ADRESL ;
            int volume = (valueH<<8) | (valueL);
            sprintf(output,"%d     \r\n",volume);
            UART_Write_Text(output);
//            }
        }
    }
    return;
}

void get_input()
{
    char input[50];
    strcpy(input , GetString());
    epoch_time = strtoll(input , &input , 10) + (long long int)28801;
}

void print_current_time()
{
    TM = gmtime( &epoch_time );
    char *output = asctime(TM);
    UART_Write_Text(output);
    UART_Write_Text("\r\n");
}

void wait_button()
{
    while(PORTBbits.RB0 == 1)
    {
        ;
    }
    PORTBbits.RB0 = 0;
    UART_Write_Text("SYNC\r\n");
}

void interrupt_setup()
{
    ADCON1 = 0x0E;
    //INTERRUPT
    INTCONbits.INT0IF = 0;
    INTCONbits.INT0IE = 1;
    //ADC INTERRUPT
//    PIR1bits.ADIF = 0;
//    PIE1bits.ADIE = 1;
//    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1; 
}

void PWM_setup()
{
    OSCCON = 0x60;
    TRISBbits.RB0 = 1;
    TRISCbits.RC2 = 0;
    ADCON1bits.PCFG = 0b1110;
    CCP1CON = 0b00001100;
    T2CON = 0b00000111;
    PR2 = 0x9b;
    CCPR1L = 4;
    T1CON = 0x30;
}

void ADC_setup()
{
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG  = 0b1110;
    ADCON0bits.CHS   = 0b0000;
    ADCON2bits.ADCS  = 0b100;
    ADCON2bits.ACQT  = 0b010;
    ADCON0bits.ADON  = 1;
    ADCON2bits.ADFM  = 1;
}

int get_volume()
{
    int valueH = ADRESH ;
    int valueL = ADRESL ;
    int value = (valueH<<8) | (valueL);
    
    if(value <=256)
        LATD = 0b00000000;
    else if(value <=512)
        LATD = 0b00000001;
    else if(value <= 768)
        LATD = 0b00000011;
    else if(value <= 1000)
        LATD = 0b00000111;
    else
        LATD = 0b00001111;
}

void _1_second()
{
    TMR1H = 0xE7;
    TMR1L = 0xA4;
    PIR1bits.TMR1IF = 0;
    T1CONbits.TMR1ON = 1;
    while(!PIR1bits.TMR1IF)
    {
        ;
    }
    T1CONbits.TMR1ON = 0;
}

void delay(int num)
{
    int i = 0;
    while(i<num)
    {
        i++;
    }
    return;
}