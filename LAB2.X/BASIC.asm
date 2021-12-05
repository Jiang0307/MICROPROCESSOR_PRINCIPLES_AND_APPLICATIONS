LIST p=18f4520
#include <p18f4520.inc>
	CONFIG OSC = INTIO67 
	CONFIG WDT = OFF 
	org 0x10

START:
    MOVLW D'9'
    MOVWF TRISA
    CLRF WREG
    LFSR 0,0x100
    LOOP1:
	MOVFF WREG,POSTINC0
	INCF WREG
	DECF TRISA
	BNZ LOOP1

    MOVLW D'9'
    MOVWF TRISA
    CLRF WREG
    LFSR 0,0x108
    LFSR 1,0x110
    LOOP2:
	MOVFF POSTINC0,POSTINC1
	DECF TRISA
	BNZ LOOP2
	
END

