LIST p=18f4520
#include <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00 


START:
    CLRF 0x000
    CLRF TRISA
    MOVLW D'15'
    
    LOOP:
	ADDWF 0x000,F
	DECFSZ WREG
	GOTO LOOP
	MOVFF 0x000,WREG
	NOP
	END
