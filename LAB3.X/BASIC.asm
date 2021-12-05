LIST p=18f4520
#include <p18f4520.inc>
	CONFIG OSC = INTIO67 
	CONFIG WDT = OFF 
	org 0x100
	
	
START:
    MOVLW 0x0F
    MOVWF TRISA
    
    
    RLCF WREG
    RRCF TRISA
    


END