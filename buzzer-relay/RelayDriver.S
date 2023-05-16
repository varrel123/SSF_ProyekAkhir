;------------------------
; Assembly Code
;Relay IN on PD5
;Button in PC0 w/ input Pullup
;------------------------
#define __SFR_OFFSET 0x00
#include "avr/io.h"
;------------------------
.global main
;===============================================================
main:
 
    LDI   R16, 0b000100000 ;to toggle PB5 (D13)
    LDI   R17, 0b00000000
    ;--------------------------------------------
    SBI   DDRD, 5         ;set PD5 for o/p
    OUT   PORTD, R17      ;PD5 = 0
    CBI   DDRC, 0         ;set PC0 as i/p
    SBI   PORTC, 0        ;input pullup
    rjmp loop

loop:
    SBIC  PINC, 0
    RJMP loop

relay_toggle:
    EOR   R17, R16        ;R17 = R17 XOR R16
    OUT   PORTD, R17  
    ;LDI   R18, 0
    RJMP  loop
    
    
relay_toggle_on:
    SBI   PORTB, 3
    RET

relay_toggle_on:
    CBI  PORTB, 3
    RET
