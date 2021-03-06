LIST p = 18f4520
#include "p18f4520.inc"
    CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    ;CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    ORG 0x00
    
    L1 EQU 0x14
    L2 EQU 0x15
    ONE_LIGHT EQU D'1'
    TWO_LIGHT EQU D'2'
    THREE_LIGHT EQU D'3'
    FOUR_LIGHT EQU D'4'
    
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

	MOVLW B'00000000'
	MOVFF WREG,LATD

    CHECK_PRESS_0:
	BTFSC PORTA,4
	BRA CHECK_PRESS_0
	BRA TURN_LIGHT_1
	
    TURN_LIGHT_1:
	MOVLW B'00000001'
	MOVFF WREG,LATD
	DELAY D'200',D'360'
	MOVLW B'00000000'
	MOVFF WREG,LATD
	
	CHECK_PRESS_1:
	    BTFSC PORTA,4
	    BRA CHECK_PRESS_1
	    BRA TURN_LIGHT_2
    
    TURN_LIGHT_2:
	MOVLW B'00000011'
	MOVFF WREG,LATD
	DELAY D'200',D'360'
	MOVLW B'00000000'
	MOVFF WREG,LATD
	
	CHECK_PRESS_2:
	    BTFSC PORTA,4
	    BRA CHECK_PRESS_2
	    BRA TURN_LIGHT_3
	    
    TURN_LIGHT_3:
	MOVLW B'00000111'
	MOVFF WREG,LATD
	DELAY D'200',D'360'
	MOVLW B'00000000'
	MOVFF WREG,LATD
	
	CHECK_PRESS_3:
	    BTFSC PORTA,4
	    BRA CHECK_PRESS_3
	    BRA TURN_LIGHT_4
    
    TURN_LIGHT_4:
	MOVLW B'00001111'
	MOVFF WREG,LATD
	DELAY D'200',D'360'
	MOVLW B'00000000'
	MOVFF WREG,LATD
	
	CHECK_PRESS_4:
	    BTFSC PORTA,4
	    BRA CHECK_PRESS_4
	    BRA TURN_LIGHT_1

    END



