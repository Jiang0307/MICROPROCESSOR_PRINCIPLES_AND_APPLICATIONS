#include <xc.h>
#include <pic18f4520.h>

#pragma config OSC = INTIO67  //OSCILLATOR SELECTION BITS (INTERNAL OSCILLATOR BLOCK, PORT FUNCTION ON RA6 AND RA7)
#pragma config WDT = OFF      //Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PWRT = OFF     //Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = ON     //Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
#pragma config PBADEN = OFF   //PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF      //Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
#pragma config CPD = OFF      //Data EEPROM Code Protection bit (Data EEPROM not code-protected)

void delay(int num)
{
    int i = 0;
    while(i<num)
        i++;
    return;
}

void __interrupt(low_priority) LO_ISR()
{
    return;
}

void __interrupt(high_priority) HI_ISR()
{
    int value_H = ADRESH;
    int value_L = ADRESL;
    
    int value = value_H * 256 + value_L;
    
    if(value < 102)
        LATD = 0b00000001;
    else if (value < 204)
        LATD = 0b00001000;
    else if (value < 306)
        LATD = 0b00000100;
    else if (value < 408)
        LATD = 0b00000010;
    else if (value < 510)
        LATD = 0b00000001;
    else if (value < 612)
        LATD = 0b00000010;
    else if (value < 714)
        LATD = 0b00000001;
    else if (value < 816)
        LATD = 0b00000100;
    else if (value < 918)
        LATD = 0b00000001;
    else if (value < 1024)
        LATD = 0b00000010;
    
    PIR1bits.ADIF = 0;
    
    delay(10);
    ADCON0bits.GO = 1;
    
    return;
}

void main(void) 
{
    OSCCONbits.IRCF = 0b110; // osc = 1MHZ
    TRISAbits.RA0 = 1; // analog input port
    TRISD = 0; 
    LATD = 0;  

    // configure ADC module
    ADCON0bits.CHS = 0b0000; // AN0?analog input
    ADCON0bits.ADON = 1;    
    
    ADCON1bits.VCFG0 = 0; // voltage reference
    ADCON1bits.VCFG1 = 0; // voltage reference
    ADCON1bits.PCFG = 0b1110; // AN0?analog input , ??ANx?digital I/O
        
    ADCON2bits.ADCS = 0b100;  // A/D conversion clock , ????001
    ADCON2bits.ACQT = 0b010; // Tad = 2us , acquisition time = 2Tad = 4us
    ADCON2bits.ADFM = 1; // left justified
    
    //configure ADC interrupt
    PIE1bits.ADIE = 1; 
    PIR1bits.ADIF = 0; 
    INTCONbits.PEIE = 1; 
    INTCONbits.GIE = 1; 
    
    //start conversion
    ADCON0bits.GO = 1;
    
    while(1);
    return;
}
