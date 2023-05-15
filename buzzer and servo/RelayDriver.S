;------------------------
; Assembly Code
;------------------------
#define __SFR_OFFSET 0x00
#include "avr/io.h"
;------------------------
.global main
;===============================================================
main:
 
    LDI   R16, 0b00000100 ;to toggle PB5 (D13)
    LDI   R17, 0b00000000
    ;--------------------------------------------
    SBI   DDRD, 2         ;set PC5 for o/p
    OUT   PORTD, R17      ;PC5 = 0
    CBI   DDRC, 0         ;set PC0 as i/p
    SBI   PORTC, 0        ;input pullup
    LDI R18, 1

agn:
    SBIC  PINC, 0
    LDI R18, 1
    SBIS  PINC, 0
    CPI   R18, 1
    BRNE  agn
    RJMP l1
    RJMP agn

l1:
    EOR   R17, R16        ;R17 = R17 XOR R16
    OUT   PORTD, R17  
    LDI   R18, 0
    RJMP  agn
