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
    value = value * 180;
    value = value / 1024;
    
    if(0<=value && value < 45)
        LATD = 0b00000001;
    else if(45<= value && value<90)
        LATD = 0b00000011;
    else if(90<= value && value<135)
        LATD = 0b00000111;
    else if(135<= value && value<180)
        LATD = 0b00001111;

    int value2 = value_H * 256 + value_L;
       
    value2 = value2 * 14;
    value2 = value2 / 1024;
    value2 += 4;
    PIR1bits.ADIF = 0;
    
    CCPR1L = value2;
    CCP1CONbits.DC1B = 0b01;
    
    delay(3);
    ADCON0bits.GO = 1;    
    
//    if(value < 64)
//        
//    else if (value < 128)
//        LATD = 0b00001000;
//    else if (value < 192)
//        LATD = 0b00000100;
//    else if (value < 256)
//        LATD = 0b00001100;
//    else if (value < 320)
//        LATD = 0b00000010;
//    else if (value < 384)
//        LATD = 0b00001010;
//    else if (value < 448)
//        LATD = 0b00000110;
//    else if (value < 512)
//        LATD = 0b00001110;
//    else if (value < 576)
//        LATD = 0b00000001;
//    else if (value < 640)
//        LATD = 0b00001001;
//    else if (value < 704)
//        LATD = 0b00000101;
//    else if (value < 768)
//        LATD = 0b00001101;
//    else if (value < 832)
//        LATD = 0b00000011;
//    else if (value < 896)
//        LATD = 0b00001011;
//    else if (value < 960)
//        LATD = 0b00000111;
//    else if (value < 1024)
//        LATD = 0b00001111;
    
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
    
    while(1)
    {
        ;
    }
    return;
}
