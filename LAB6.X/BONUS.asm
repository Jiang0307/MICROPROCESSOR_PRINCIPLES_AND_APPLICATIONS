LIST p = 18f4520
#include "p18f4520.inc"
    CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    ORG 0x00
    
    L1 EQU 0x14
    L2 EQU 0x15
  
    DELAY MACRO NUM1,NUM2
	LOCAL LOOP1
	LOCAL LOOP2
	MOVLW NUM2
	MOVWF L2
	LOOP2:
	    MOVLW NUM1
	    MOVWF L1
	LOOP1:
	    ;check if pressed repeatly in the nested loop
	    BTFSS PORTA,4  ;unpressed
	    BSF 0x000,0	    ;if pressed set 0x000 to 1
	    
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

    STATE_0:
	CLRF 0x000
    	MOVLW B'00000000'
	MOVFF WREG,LATD
	DELAY D'200',D'360'

	BTFSS	0x000,0	
	BRA STATE_0	;pressed
	CLRF 0x000
	BRA STATE_1	;unpressed
	
    STATE_1:
	_1_1:
	    CLRF 0x000
	    MOVLW B'00000001'
	    MOVFF WREG,LATD
	    DELAY D'200',D'360'
	    MOVLW B'00000000'
	    MOVFF WREG,LATD
	    BTFSS	0x000,0	
	    BRA _1_2		;unpressed
	    CLRF 0x000
	    BRA STATE_2	;pressed
	_1_2:
	    CLRF 0x000
	    MOVLW B'00000010'
	    MOVFF WREG,LATD
	    DELAY D'200',D'360'
	    MOVLW B'00000000'
	    MOVFF WREG,LATD
	    BTFSS	0x000,0	
	    BRA _1_3		;unpressed
	    CLRF 0x000
	    BRA STATE_2	;pressed
	_1_3:
	    CLRF 0x000
	    MOVLW B'00000100'
	    MOVFF WREG,LATD
	    DELAY D'200',D'360'
	    MOVLW B'00000000'
	    MOVFF WREG,LATD
	    BTFSS	0x000,0	
	    BRA _1_4		;unpressed
	    CLRF 0x000
	    BRA STATE_2	;pressed
	_1_4:
	    CLRF 0x000
	    MOVLW B'00001000'
	    MOVFF WREG,LATD
	    DELAY D'200',D'360'
	    MOVLW B'00000000'
	    MOVFF WREG,LATD
	    BTFSS	0x000,0	
	    BRA _1_1		;unpressed
	    CLRF 0x000
	    BRA STATE_2	;pressed
	
    STATE_2:  
	_2_1:
	    CLRF 0x000
	    MOVLW B'00000011'
	    MOVFF WREG,LATD
	    DELAY D'200',D'360'
	    MOVLW B'00000000'
	    MOVFF WREG,LATD
	    BTFSS 0x000,0	
	    BRA _2_2		;unpressed
	    CLRF 0x000
	    BRA STATE_3	;pressed
	_2_2:
	    CLRF 0x000
	    MOVLW B'00000110'
	    MOVFF WREG,LATD
	    DELAY D'200',D'360'
	    MOVLW B'00000000'
	    MOVFF WREG,LATD
	    BTFSS 0x000,0	
	    BRA _2_3		;unpressed
	    CLRF 0x000
	    BRA STATE_3	;pressed
	_2_3:
	    CLRF 0x000
	    MOVLW B'00001100'
	    MOVFF WREG,LATD
	    DELAY D'200',D'360'
	    MOVLW B'00000000'
	    MOVFF WREG,LATD
	    BTFSS 0x000,0	
	    BRA _2_4	    	;unpressed
	    CLRF 0x000
	    BRA STATE_3	;pressed
	_2_4:
	    CLRF 0x000
	    MOVLW B'00001001'
	    MOVFF WREG,LATD
	    DELAY D'200',D'360'
	    MOVLW B'00000000'
	    MOVFF WREG,LATD
	    BTFSS 0x000,0	
	    BRA _2_1		;unpressed
	    CLRF 0x000
	    BRA STATE_3	;pressed

    STATE_3:
	_3_1:
	    CLRF 0x000
	    MOVLW B'00000111'
	    MOVFF WREG,LATD
	    DELAY D'200',D'360'
	    MOVLW B'00000000'
	    MOVFF WREG,LATD
	    BTFSS 0x000,0	
	    BRA _3_2		;unpressed
	    CLRF 0x000
	    BRA STATE_0	;pressed
	_3_2:
	    CLRF 0x000
	    MOVLW B'00001110'
	    MOVFF WREG,LATD
	    DELAY D'200',D'360'
	    MOVLW B'00000000'
	    MOVFF WREG,LATD
	    BTFSS 0x000,0	
	    BRA _3_3		;unpressed
	    CLRF 0x000
	    BRA STATE_0	;pressed
	_3_3:
	    CLRF 0x000
	    MOVLW B'00001101'
	    MOVFF WREG,LATD
	    DELAY D'200',D'360'
	    MOVLW B'00000000'
	    MOVFF WREG,LATD
	    BTFSS 0x000,0	
	    BRA _3_4		;unpressed
	    CLRF 0x000
	    BRA STATE_0	;pressed
	_3_4:
	    CLRF 0x000
	    MOVLW B'00001011'
	    MOVFF WREG,LATD
	    DELAY D'200',D'360'
	    MOVLW B'00000000'
	    MOVFF WREG,LATD	
	    BTFSS 0x000,0	
	    BRA _3_1		;unpressed
	    CLRF 0x000
	    BRA STATE_0	;pressed
	    		
    END