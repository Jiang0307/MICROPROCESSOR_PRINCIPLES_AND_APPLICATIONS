#include "xc.inc"
GLOBAL _mysqrt
    
PSECT mytext, local, class=CODE, reloc=2

_mysqrt:
    RESET_REGISTERS:
	CLRF 0x000 ;ans
	CLRF TRISA ;i
    
    MOVFF 0x002,0x010  
    MOVFF 0x001,0x011
    
    LOOP:
	CLRF 0x020
	CLRF 0x021
	
	MOVFF TRISA,WREG
	MULWF TRISA
	MOVFF PRODH,0x020
	MOVFF PRODL,0x021
	
	;COMPARE WITH N
	COMPARE_HIGHBYTE:
	    MOVFF 0x010,WREG
	    CPFSGT 0x020
	    GOTO COMPARE_IF_HIGHBYTE_EQUAL
	    GOTO HIGHER_THAN_N
	    
	    ;
	    COMPARE_IF_HIGHBYTE_EQUAL: ;COMPARE_LOWBYTE : only when highbyte are the same
		MOVFF 0x010,WREG
		CPFSEQ 0x020
		GOTO AGAIN
		GOTO COMPARE_LOWBYTE 
	    
	COMPARE_LOWBYTE:
	    MOVFF 0x011,WREG
	    CPFSGT 0x021
	    GOTO AGAIN
	    GOTO HIGHER_THAN_N      ;90 A9
	    
	AGAIN:
	    INCF TRISA ;i++
	    INCF 0x000 ;ans++
	    GOTO LOOP
	    
	HIGHER_THAN_N:
	    DECF 0x000
	    MOVFF 0x000,WREG
	    MOVWF 0x001,F
	    
	    RETURN