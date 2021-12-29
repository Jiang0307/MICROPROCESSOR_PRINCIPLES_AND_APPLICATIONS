#include <xc.h>

char buffer[20];
int lenStr = 0;

void UART_Initialize() 
{
    
//     TODObasic   
//     Serial Setting      
//     1.   Setting Baud rate
//     2.   choose sync/async mode 
//     3.   enable Serial port (configures RX/DT and TX/CK pins as serial port pins)
//     3.5  enable Tx, Rx Interrupt(optional)
//     4.   Enable Tx & RX

    TRISCbits.TRISC6 = 1;
    TRISCbits.TRISC7 = 1;
    
    OSCCONbits.IRCF2 = 1;
    OSCCONbits.IRCF1 = 0;
    OSCCONbits.IRCF0 = 1;

    // Setting baud rate
    TXSTAbits.SYNC = 0;
    BAUDCONbits.BRG16 = 0;
    TXSTAbits.BRGH = 0;
    SPBRG = 12;
   // Serial enable
    RCSTAbits.SPEN = 1;
    PIR1bits.TXIF =0;
    PIR1bits.RCIF =0;
    TXSTAbits.TXEN = 1;
    RCSTAbits.CREN = 1;
    PIE1bits.TXIE = 0;
    IPR1bits.TXIP = 0;
    PIE1bits.RCIE = 0;
    IPR1bits.RCIP = 0;
}

void VR_Initialize()
{
    TRISAbits.RA0 = 1; // analog input port
    TRISD = 0; 
    LATD = 0;  

    // configure ADC module
    ADCON0bits.CHS = 0b0000; // AN0?analog input
    ADCON0bits.ADON = 1;    
    
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110;
        
    ADCON2bits.ADCS = 0b000;   // Tosc = 0.5us , Tad = 0.5 * 2 > 0.7
    ADCON2bits.ACQT = 0b010;   // Tad =1us , acquisition time = 4Tad = 4us
    ADCON2bits.ADFM = 1;           // left justified
    
    // configure ADC interrupt
    PIE1bits.ADIE = 0; 
    PIR1bits.ADIF = 0; 
    INTCONbits.PEIE = 0; 
    INTCONbits.GIE = 0; 
    
    // start conversion
    ADCON0bits.GO = 1;
    return;
}


void UART_Write(unsigned char data)  // Output on Terminal
{
    while(!TXSTAbits.TRMT)
    {
        ;
    }
    if(data=='\r' || data=='\n')
    {
        TXREG = '\r';
        while(!TXSTAbits.TRMT)
        {
            ;
        }
        TXREG = '\n';
    }
    else
    {
        TXREG = data; // write to TXREG will send data 
    }
}

char *GetString()
{
    for(int i = 0 ; i < 20 ; i++)
    {
        while(!RCIF)
        {
            ;
        }
        RCIF = 0;
        unsigned char c = RCREG;
        if(c == '\r' || c=='\n')
        {
            UART_Write('\r');
            break;
        }
        else    
        {
            buffer[i] = c;
            UART_Write(c);
        }
    }
    return buffer;
}

void UART_Write_Text(char* text) // Output on Terminal, limit:10 chars
{
    for(int i = 0 ; text[i] != '\0' ; i++)
        UART_Write(text[i]);
}

void ClearBuffer()
{
    for(int i = 0 ; i < 20 ; i++)
        buffer[i] = '\0';
    lenStr = 0;
}

void MyusartRead()
{
    while(!RCIF)
    {
        ;
    }
    RCIF = 0;
    unsigned char c = RCREG;
    UART_Write(c);
    // TODObasic: try to use UART_Write to finish this function
    return ;
}

void __interrupt(low_priority)  Lo_ISR(void)
{
    if(RCIF)
    {
        if(RCSTAbits.OERR)
        {
            CREN = 0;
            Nop();
            CREN = 1;
        }
        
        MyusartRead();
    }
    
   // process other interrupt sources here, if required
    return;
}