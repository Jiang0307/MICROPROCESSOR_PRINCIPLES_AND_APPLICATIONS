#include "p18f4520.inc"
; CONFIG1H
CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)
; CONFIG2L
CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)
; CONFIG2H
CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)
; CONFIG3H
CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
; CONFIG4L
CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))
; CONFIG5L
CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)
; CONFIG5H
CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)
; CONFIG6L
CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)
; CONFIG6H
CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)
; CONFIG7L
CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)
; CONFIG7H
CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)
    
ORG 0x000
GOTO START
  
Initial:
    L1  EQU 0x14
    L2  EQU 0x15
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
		    
ISR:
    ORG 0x008
    BCF INTCON , INT0IE
    BCF	 INTCON , INT0IF
    BSF	 OCCUR , 7
    RETFIE
    

START:
    OCCUR EQU 0x000
    CLRF TRISB     ; RB0 : input
    CLRF TRISD	    ; clear output
    CLRF LATD	    ; RD0 ~ RD3 : output (TRISD = 0000_0000)
    
    BSF INTCON , GIE
    BSF RCON , IPEN
    BSF	 INTCON , INT0IE

    CLRF OCCUR
    GOTO STATE_1
    
STATE_1:
    CLRF OCCUR
    BSF INTCON , INT0IE
    _1_1:
	MOVLW B'00000001'
	MOVWF LATD
	DELAY 200,80
	BTFSS OCCUR,7
	GOTO _1_2
	GOTO STATE_2
    _1_2:
	MOVLW B'00000010'
	MOVWF LATD
	DELAY 200,80
	BTFSS OCCUR,7
	GOTO _1_3
	GOTO STATE_2
    _1_3:
	MOVLW B'00000100'
	MOVWF LATD
	DELAY 200,80
	BTFSS OCCUR,7
	GOTO _1_4
	GOTO STATE_2
    _1_4:
	MOVLW B'00001000'
	MOVWF LATD
	DELAY 200,80
	BTFSS OCCUR,7
	GOTO STATE_1
	GOTO STATE_2
    
STATE_2:
    CLRF OCCUR
    BSF INTCON , INT0IE
    
    _2_1:
	MOVLW B'00000001'
	MOVWF LATD
	DELAY 200,40
	BTFSS OCCUR,7
	GOTO _2_2
	GOTO STATE_2
    _2_2:
	MOVLW B'00000010'
	MOVWF LATD
	DELAY 200,40
	BTFSS OCCUR,7
	GOTO _2_3
	GOTO STATE_2
    _2_3:
	MOVLW B'00000100'
	MOVWF LATD
	DELAY 200,40
	BTFSS OCCUR,7
	GOTO _2_4
	GOTO STATE_2
    _2_4:
	MOVLW B'00001000'
	MOVWF LATD
	DELAY 200,40
	BTFSS OCCUR,7
	GOTO STATE_2
	GOTO STATE_3
	
STATE_3:
    CLRF OCCUR
    BSF INTCON , INT0IE
    _3_1:
	MOVLW B'00000001'
	MOVWF LATD
	DELAY 200,20
	BTFSS OCCUR,7
	GOTO _3_2
	GOTO STATE_1
    _3_2:
	MOVLW B'00000010'
	MOVWF LATD
	DELAY 200,20
	BTFSS OCCUR,7
	GOTO _3_3
	GOTO STATE_1
    _3_3:
	MOVLW B'00000100'
	MOVWF LATD
	DELAY 200,20
	BTFSS OCCUR,7
	GOTO _3_4
	GOTO STATE_1
    _3_4:
	MOVLW B'00001000'
	MOVWF LATD
	DELAY 200,20
	BTFSS OCCUR,7
	GOTO STATE_3
	GOTO STATE_1
    
END