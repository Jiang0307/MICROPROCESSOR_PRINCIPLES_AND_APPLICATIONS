LIST p=18f4520
#include <p18f4520.inc>
	CONFIG OSC = INTIO67 
	CONFIG WDT = OFF 
	org 0x00
	    
set_value:
    MOVLB D'1'
    
    MOVLW 0xB5
    MOVWF 0x100,1
    
    MOVLW 0xF3
    MOVWF 0x101,1
    
    MOVLW 0x64
    MOVWF 0x102,1
    
    MOVLW 0x7F
    MOVWF 0x103,1
    
    MOVLW 0x98
    MOVWF 0x104,1
    
start:
    CLRF TRISA
    CLRF TRISB
    CLRF TRISC
    CLRF TRISD
    
    MOVLW D'5'
    MOVWF TRISA
    MOVLW D'4'
    MOVWF TRISB
    goto LOOP1
    
LOOP1:
    MOVFF TRISB,TRISC ;TRISC??4
    LFSR 0,0x100 ;FSR0??0x100
    goto LOOP2
    
    LOOP2:
	NOP POSTINC0 ;i++
	MOVFF INDF0,WREG ;WREG = [i+1] ?i+1??WREG
	NOP POSTDEC0 ;i--
	
	;-------------------swap-------------------
	CPFSGT INDF0		       
	MOVFF POSTINC0,TRISD ;
	CPFSGT INDF0
	MOVFF POSTDEC0,POSTINC0 ;
	CPFSGT INDF0
	MOVFF TRISD,INDF0
	;-------------------swap-------------------
	DECFSZ TRISC
	goto LOOP2
	goto continue
	continue:
	    DECFSZ TRISA
	    goto LOOP1
	    goto terminal

terminal:
    end