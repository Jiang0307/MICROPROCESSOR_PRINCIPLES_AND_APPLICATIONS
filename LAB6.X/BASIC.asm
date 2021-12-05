LIST p = 18f4520
#include "p18f4520.inc"
    CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    ;CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  
    L1 EQU 0x14
    L2 EQU 0x15
    ORG 0x00
    
    DELAY MACRO NUM1,NUM2
	LOCAL LOOP1
	LOCAL LOOP2
	MOVLW NUM2
	MOVWF L2
	LOOP2:
	    MOVLW NUM1
	    MOVWF L1
	LOOP1:
	    NOP
	    NOP
	    NOP
	    NOP
	    NOP
	    DECFSZ L1,1
	    BRA LOOP1
	    DECFSZ L2,1
	    BRA LOOP2
    ENDM
    
    START:
    	MOVLW 0b00001111
	MOVWF ADCON1
	
	CLRF TRISA
	BSF TRISA,4
		
	CLRF TRISD
	BCF TRISD,0
	BCF TRISD,1
	BCF TRISD,2
	BCF TRISD,3

	MOVLW B'00001010'
	MOVFF WREG,LATD

    CHECK_PRESS:
	BTFSC PORTA,4
	BRA CHECK_PRESS
	BRA TURN_LIGHT_UP
	
	
    TURN_LIGHT_UP:
	BTG LATD,0
	BTG LATD,1
	BTG LATD,2
	BTG LATD,3
	DELAY D'200',D'180'
	BRA CHECK_PRESS
    
    END
