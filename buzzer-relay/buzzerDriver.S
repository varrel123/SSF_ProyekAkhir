;------------------------
; Assembly Code
;------------------------
#define __SFR_OFFSET 0x00
#include "avr/io.h"
;------------------------
.global main
;===============================================================
main:
    LDI   R16, 0b00100000 ;to toggle PB5 (D13)
    LDI   R17, 0b00000000
    ;--------------------------------------------
    SBI   DDRB, 5         ;set PB5 for o/p
    OUT   PORTB, R17      ;PB5 = 0
    CBI   DDRC, 0
    SBI   PORTC, 0
    LDI R18, 100
agn:
    LDI   R17, 0b00000000
    OUT   PORTB, R17
    SBIS  PINC, 0
    RJMP l1
    RJMP agn

;Subroutine to generate 1000hz square-wave
l1: RCALL delayhalfms   ;apply delay via timer0
    ;--------------------------------------------
    EOR   R17, R16        ;R17 = R17 XOR R16
    OUT   PORTB, R17  
    SBIS  PINC, 0         ;toggle PB5      
    RJMP  l1              ;go back & repeat toggle
    RJMP  agn
;===============================================================
delayhalfms:             ;0.5 ms delay via Timer0 for generating 1kHz tone
    ;---------------------------------------------------------
    CLR   R20
    OUT   TCNT0, R20      ;initialize timer0 with count=0
    LDI   R20, 125
    OUT   OCR0A, R20      ;OCR0 = 125
    LDI   R20, 0b00001011
    OUT   TCCR0B, R20     ;timer0: CTC mode, prescaler 64
    ;---------------------------------------------------------
l2: IN    R20, TIFR0      ;get TIFR0 byte & check
    SBRS  R20, OCF0A      ;if OCF0=1, skip next instruction
    RJMP  l2              ;else, loop back & check OCF0 flag
    ;---------------------------------------------------------
    CLR   R20
    OUT   TCCR0B, R20     ;stop timer0
    ;---------------------------------------------------------
    LDI   R20, (1<<OCF0A)
    OUT   TIFR0, R20      ;clear OCF0 flag
    RET
    
    
buzzer_toggle_on:
    SBI   PORTB, 1
    RET

buzzer_toggle_on:
    CBI  PORTB, 1
    RET
