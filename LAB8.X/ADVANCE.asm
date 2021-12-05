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
        
;TIMER2 : 8 bit
ISR:
        ORG 0x008
        BCF PIR1,TMR2IF  ;DISABLE FLAG BIT

        CLRF WREG
         ;DETERMINE THE LIGHT STATE FIRST , IF THE CURRENT  STATE IS 0 LIGHT DETERMINE THE LIGHT UP INTERVAL
        CPFSEQ LATD
        GOTO CONTINUE
        GOTO ALL_ZERO
        ;LIGHT STATES
        ALL_ZERO:
                MOVLW B'00000001'
                MOVWF LATD
                GOTO DETERMINE_TIME
          
        CONTINUE:
                ;CHECK WHETHER LIGHT3 IS UP
                BTFSS LATD,3
                GOTO LEFT_SHIFT
                GOTO ZERO_LIGHT
                LEFT_SHIFT:
                        RLCF LATD
                        GOTO ISR_END
                ZERO_LIGHT:
                        CLRF LATD
                        GOTO ISR_END
        ;CHECK 0x000's STATE TO DETERMINE THE LIGHT UP INTERVAL
        DETERMINE_TIME:
                BTFSS 0x000,0
                GOTO _0.5_OR_0.25
                GOTO _1.0
        _0.5_OR_0.25:
                BTFSS 0x000,1
                GOTO _0.25
                GOTO _0.5
                _1.0:
                        MOVLW D'244'
                        MOVWF PR2
                        MOVLW B'00000010'
                        MOVWF 0x000
                        GOTO ISR_END
                _0.5:
                        MOVLW D'122'
                        MOVWF PR2
                        MOVLW B'00000100'
                        MOVWF 0x000
                        GOTO ISR_END
                _0.25:
                        MOVLW D'61'
                        MOVWF PR2
                        MOVLW B'00000001'
                        MOVWF 0x000
                        GOTO ISR_END
        ISR_END:
                RETFIE

INITIALIZE:
        ;INITIALIZE OSCILLATOR TO 250KHZ
        BCF OSCCON,6
        BSF OSCCON,5
        BCF OSCCON,4
        ;ENABLE AND DISABLE BITS
        BSF IPR1,TMR2IP
        BCF PIR1,TMR2IF
        BSF PIE1,TMR2IE
        ;INITIALIZE IO
        MOVLW B'00000001'
        MOVWF 0x000
        CLRF TRISD
        MOVLW B'00000000'
        MOVWF  LATD
        ;INITIALIZE TIMER 2
        MOVLW B'11111111'   ;CONFIGURATION
        MOVWF T2CON
        MOVLW D'244'              ;IF TMR2 = PR2 = 244  -->  ISR
        MOVWF PR2
        CLRF TMR2
        RETURN
        
START:
        CALL INITIALIZE
        BSF RCON,IPEN
        BSF INTCON,GIEH
        
MAIN:
        GOTO MAIN
        
NEVER_GO_HERE:
        END