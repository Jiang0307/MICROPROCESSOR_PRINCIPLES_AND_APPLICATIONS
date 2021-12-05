LIST p=18f4520
#include <p18f4520.inc>
    CONFIG OSC = INTIO67 
    CONFIG WDT = OFF 
    ORG 0x00

Initial:
    MOVLF MACRO literal,F
	MOVLW literal
	MOVWF F
	CLRF WREG
    ENDM
    RECT MACRO addr_x1 , addr_y1 , addr_x2 , addr_y2 , F
	MOVFF addr_x2,WREG
	SUBWF addr_x1,W
	MOVWF TRISA
	
	MOVFF addr_y2,WREG
	SUBWF addr_y1,W
	MOVWF TRISB
	MOVFF TRISA,WREG
	MULWF TRISB
	MOVFF PRODL,F
	CLRF WREG
     ENDM


    
start:
    MOVLF 0x03,0x000
    MOVLF 0x09,0x001
    MOVLF 0x07,0x002
    MOVLF 0x0f,0x003
    RECT 0x000,0x001,0x002,0x003,0x004
    END



