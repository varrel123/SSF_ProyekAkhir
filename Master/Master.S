;------------------------
; Assembly Code
;------------------------
#define __SFR_OFFSET 0x00
#include "avr/io.h"
;------------------------
.global main
;==============================================================
main:
  .equ SCK, 5
  .equ MOSI, 3
  .equ SS, 2

  ;--------------------------------------------------------------
  ; SPI for DHT
  ;--------------------------------------------------------------
  LDI R17, (1<<MOSI)|(1<<SCK)|(1<<SS)
  OUT DDRD, R17       ; set MOSI, SCK, SS as o/p
  LDI R17, (1<<SPE)|(1<<MSTR)|(1<<SPR0)
  OUT SPCR, R17       ; enable SPI as master, fsck=fosc/16, mode 0
  RJMP  again
RET

again:
  ;--------------------------------------------------------
  ; SPI for DHT
  ;--------------------------------------------------------
  RCALL dht_start     ;data read in R18
  CBI PORTD, SS       ;enable slave device
  CLR R18
  LDI R18, 0x30
  OUT SPDR, R18       ;transmit byte to slave
  loop: 
    IN R18, SPSR
    SBRS R18, SPIF    ;wait for byte transmission
    RJMP loop         ;to complete
  SBI PORTD, SS       ;disable slave device
  ;--------------------------------------------------------

  RCALL delay_4sec    ;delay N second
  RJMP again          ;repeat transmission
  ;==============================================================

dht_start:
  SBI DDRD, 5       ;pin PB0 as o/p
  CBI PORTD, 5      ;first, send low pulse
  RCALL delay_20ms  ;for 20ms
  SBI PORTD, 5      ;then send high pulse

  ;wait for response from dht11
  CBI DDRD, 5       ;pin PB0 as i/p
  w1: SBIC PIND, 5
  RJMP w1           ;wait for DHT11 low pulse
  w2: SBIS PIND, 5
  RJMP w2           ;wait for DHT11 high pulse
  w3: SBIC PIND, 5
  RJMP w3           ;wait for DHT11 low pulse

  RCALL DHT11_reading ;read humidity (1st byte of 40-bit data)
  RCALL DHT11_reading
  RCALL DHT11_reading ;read temp (3rd byte of 40-bit data)
  RET

DHT11_reading:
  LDI R17, 8          ;set counter for receiving 8 bits
  CLR R18             ;clear data register
  ;-------------------------------------------------------
  w4: SBIS PIND, 5
  RJMP w4             ;detect data bit (high pulse)
  RCALL delay_timer0  ;wait 50us & then check bit value
  ;-------------------------------------------------------
  SBIS PIND, 5        ;if received bit=1, skip next inst
  RJMP skp            ;else, received bit=0, jump to skp
  SEC                 ;set carry flag (C=1)
  ROL R18             ;shift in 1 into LSB data register
  RJMP w5             ;jump & wait for low pulse
  skp:LSL R18         ;shift in 0 into LSB data register
  ;-------------------------------------------------------
  w5: SBIC PIND, 5
  RJMP w5             ;wait for DHT11 low pulse
  ;-------------------------------------------------------
  DEC R17             ;decrement counter
  BRNE w4             ;go back & detect next bit
  RET                 ;return to calling subroutine 
 
delay_20ms: ;delay 20ms
  LDI R21, 255
  l3: LDI R22, 210
  l4: LDI R23, 2
  l5: DEC R23
  BRNE l5
  DEC R22
  BRNE l4
  DEC R21
  BRNE l3
  RET

delay_timer0: ;50 usec delay via Timer 0
  ;---------------------------------------------------------
  CLR R20
  OUT TCNT0, R20 ;initialize timer0 with count=0
  LDI R20, 100
  OUT OCR0A, R20 ;OCR0 = 100
  LDI R20, 0b00001010
  OUT TCCR0B, R20 ;timer0: CTC mode, prescaler 8
  ;---------------------------------------------------------
  lo2: IN R20, TIFR0 ;get TIFR0 byte & check
  SBRS R20, OCF0A ;if OCF0=1, skip next instruction
  RJMP lo2 ;else, loop back & check OCF0 flag
  ;---------------------------------------------------------
  CLR R20
  OUT TCCR0B, R20 ;stop timer0
  ;---------------------------------------------------------
  LDI R20, (1<<OCF0A)
  OUT TIFR0, R20 ;clear OCF0 flag
  RET

delay_4sec: ;4 sec delay via timer1
  ;-------------------------------------------------------
  .EQU value, 3036
  LDI R20, hi8(value)
  STS TCNT1H, R20
  LDI R20, lo8(value)
  STS TCNT1L, R20 ;initialize counter TCNT1 = 3036
  ;-------------------------------------------------------
  LDI R20, 0b00000000
  STS TCCR1A, R20
  LDI R20, 0b00000101
  STS TCCR1B, R20 ;normal mode, prescaler = 1024
  ;-------------------------------------------------------
  l2: IN R20, TIFR1 ;get TIFR1 byte & check
  SBRS R20, TOV1 ;if TOV1=1, skip next instruction
  RJMP l2 ;else, loop back & check TOV1 flag
  ;-------------------------------------------------------
  LDI R20, 1<<TOV1
  OUT TIFR1, R20 ;clear TOV1 flag
  ;-------------------------------------------------------
  LDI R20, 0b00000000
  STS TCCR1B, R20 ;stop timer0
  RET

