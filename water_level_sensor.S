#define __SFR_OFFSET 0
#include "avr/io.h"

.global main

RCALL

agn:
RCALL read_ADC
RJMP agn


main:
LDI R20, 0xFF ; load 0xFF to R20
OUT DDRD, R20 ; set port D as o/p for low byte result

init_ADC:
SBI DDRC, 0     ;set pin PC0 as i/p for ADC0
LDI R20, 0xC0   ;internal 2.56V, right-justified data, ADC0
OUT DDRC, R20 ; set port C as o/p for high byte result
SBI DDRC, 0x02 ; set pin PC0 as i/p for ADC2 (A2)
LDI R20, 0x02 ; internal 2.56V, right-justified data, ADC2(A2)
STS ADMUX, R20 ; set ADMUX to select ADC2(A2)
LDI R20, 0x87 ; enable ADC, ADC prescaler CLK/128
STS ADCSRA, R20 ; set ADCSRA to enable ADC


read_ADC:
LDI R20, 0xC7
STS ADCSRA, R20

wait_ADC:
LDS R21, ADCSRA
SBRS R21,4
RJMP wait_ADC
LDI R17,0xD7
STS ADCSRA,R17

LDS R18,ADCL
LDS R19,ADCH