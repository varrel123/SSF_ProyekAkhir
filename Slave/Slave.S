;---------------
; Assembly Code
;---------------
#define __SFR_OFFSET 0x00
#include "avr/io.h"
;------------------------

.global main
;====================================================================

;============================================================
SPI_slave:
;------------------------------------------------------------

main:
    SBI   DDRC, 0       ;set pin PC0 as i/p for ADC0
    ;-------------------------------------------------------------
    LDI   R20, 0xE0     ;internal 2.56V, left-justified data, ADC0
    STS   ADMUX, R20
    LDI   R20, 0x87     ;enable ADC, ADC prescaler CLK/128
    STS   ADCSRA, R20
      LDI R21, 0xF0
  OUT DDRD, R21 ;port D[7:4] is o/p
  LDI R17, (1<<SPE)
  OUT SPCR, R17 ;enable SPI as slave

  ;-------------------------------------------------------
  ; SPI reading
  ;-------------------------------------------------------
  l22:
    IN R18, SPSR
    SBRS R18, SPIF  ;wait for byte reception
    ;RJMP l22

  IN R28, SPDR       ;i/p byte from data register
  RCALL LCD_write
  RJMP main
;------------------------------------------------------------------
LCD_write:
    LDI   R23, 48       ;constants used to get ASCII values
    LDI   R24, 7        ;for chars 0-->9 & A-->F
    ;--------------------------------------------------
    LDI   R16, 0xFF
    OUT   DDRD, R16     ;set port D o/p for data
    OUT   DDRB, R16     ;set port B o/p for command
    CBI   PORTB, 0      ;EN = 0
    RCALL delay_ms      ;wait for LCD power on
    ;--------------------------------------------------
    RCALL LCD_init      ;subroutine to initialize LCD
    ;--------------------------------------------------
    RCALL disp_msg      ;display message on 1st line
    ;--------------------------------------------------
 ;   LDI   R16, 0xC0     ;cursor beginning of 2nd line
;    RCALL command_wrt
    RCALL delay_ms
    ;--------------------------------------------------
        LDI   R16, 0x20
    RCALL data_wrt      ;display LSD on LCD
    LDI   R19, 48       ;constant to get ASCII chars 0 to 9
    RJMP  encrypt   ;display ADC 8-bit value on LCD
;====================================================================
LCD_init:
    LDI   R16, 0x33     ;init LCD for 4-bit data
    RCALL command_wrt   ;send to command register
    RCALL delay_ms
    LDI   R16, 0x32     ;init LCD for 4-bit data
    RCALL command_wrt
    RCALL delay_ms
    LDI   R16, 0x28     ;LCD 2 lines, 5x7 matrix
    RCALL command_wrt
    RCALL delay_ms
    LDI   R16, 0x0C     ;disp ON, cursor OFF
    RCALL command_wrt
    LDI   R16, 0x01     ;clear LCD
    RCALL command_wrt
    RCALL delay_ms
    LDI   R16, 0x06     ;shift cursor right
    RCALL command_wrt
    RET  
;====================================================================
command_wrt:
    MOV   R27, R16
    ANDI  R27, 0xF0     ;mask low nibble & keep high nibble
    OUT   PORTD, R27    ;o/p high nibble to port D
    CBI   PORTB, 1      ;RS = 0 for command
    SBI   PORTB, 0      ;EN = 1
    RCALL delay_short   ;widen EN pulse
    CBI   PORTB, 0      ;EN = 0 for H-to-L pulse
    RCALL delay_us      ;delay 100us
    ;-------------------------------------------------------
    MOV   R27, R16
    SWAP  R27           ;swap nibbles
    ANDI  R27, 0xF0     ;mask low nibble & keep high nibble
    OUT   PORTD, R27    ;o/p high nibble to port D
    SBI   PORTB, 0      ;EN = 1
    RCALL delay_short   ;widen EN pulse
    CBI   PORTB, 0      ;EN = 0 for H-to-L pulse
    RCALL delay_us      ;delay 100us
    RET
;====================================================================
data_wrt:
    MOV   R27, R16
    ANDI  R27, 0xF0     ;mask low nibble & keep high nibble
    OUT   PORTD, R27    ;o/p high nibble to port D
    SBI   PORTB, 1      ;RS = 1 for data
    SBI   PORTB, 0      ;EN = 1
    RCALL delay_short   ;make wide EN pulse
    CBI   PORTB, 0      ;EN = 0 for H-to-L pulse
    RCALL delay_us      ;delay 100us
    ;-------------------------------------------------------
    MOV   R27, R16
    SWAP  R27           ;swap nibbles
    ANDI  R27, 0xF0     ;mask low nibble & keep high nibble
    OUT   PORTD, R27    ;o/p high nibble to port D
    SBI   PORTB, 0      ;EN = 1
    RCALL delay_short   ;widen EN pulse
    CBI   PORTB, 0      ;EN = 0 for H-to-L pulse
    RCALL delay_us      ;delay in micro seconds
    RET
;====================================================================
delay_short:            ;very short delay, 3 cycles
    NOP
    NOP
    RET
;--------------------------------------------------
delay_us:               ;delay approximately 100us
    LDI   R20, 90
l1: RCALL delay_short
    DEC   R20
    BRNE  l1
    RET
;--------------------------------------------------
delay_ms:               ;delay approximately 20ms
    LDI   R21, 40
l2: RCALL delay_us
    DEC   R21
    BRNE  l2
    RET
;----------------------------------------------------------------
delay_sec:              ;nested loop subroutine (max delay 3.11s)
    LDI   R20, 255      ;outer loop counter 
l3: LDI   R21, 255      ;mid loop counter
l4: LDI   R22, 40       ;inner loop counter to give 0.5s delay
l5: DEC   R22           ;decrement inner loop
    BRNE  l5            ;loop if not zero
    DEC   R21           ;decrement mid loop
    BRNE  l4            ;loop if not zero
    DEC   R20           ;decrement outer loop
    BRNE  l3            ;loop if not zero
    RET                 ;return to caller
;====================================================================
disp_msg1:
    LDI   R31, hi8(msg1)
    LDI   R30, lo8(msg1) ;Z points to string msg
l61: LPM   R16, Z+       ;load character of msg into R16
    CPI   R16, 0x20        ;check if R16=0 (end of string)
    BREQ  ext1           ;if yes, exit
    RCALL data_wrt      ;if no, display character on LCD
    RJMP  l61            ;loop back & get next character
ext1:
    ; LDI R16, 48
    ; RCALL data_wrt 
    RET
;--------------------------------------------------------------------
msg1: .ascii "WaterLvl: " ;use even number of chars in string
                               ;odd number gives compilation error!!!

disp_msg:
    LDI   R31, hi8(msg)
    LDI   R30, lo8(msg) ;Z points to string msg
l6: LPM   R16, Z+       ;load character of msg into R16
    CPI   R16, 0x20        ;check if R16=0 (end of string)
    BREQ  ext           ;if yes, exit
    RCALL data_wrt      ;if no, display character on LCD
    RJMP  l6            ;loop back & get next character
ext:RET
;--------------------------------------------------------------------
msg: .ascii "Temp: " ;use even number of chars in string
                               ;odd number gives compilation error!!!
;====================================================================
clr:
    LDI   R20, 0xC7     ;set ADSC in ADCSRA to start conversion
    STS   ADCSRA, R20
    ;----------------------------------------------------------------
encrypt:
    MOV   R16, R18     ;get high-byte result from ADCH    
    ;----------------------------------------------------------------
    CLR   R25           ;set counter1, initial value 0
    CLR   R23           ;set counter2, initial value 0
    ;----------------------------------------------------------------
    CPI   R16, 228      ;compare R16 with 228
    BRPL  adjust        ;jump if R16 >= 228
    ;----------------------------------------------------------------
l7: CPI   R16, 100      ;compare R16 with 100
Ret:BRMI  l8            ;jump when R16 < 100
    INC   R25           ;increment counter1 by 1
    SUBI  R16, 100      ;R16 = R16 - 100
    RJMP  l7
    ;-----------------------------------------------------------------
l8: CPI   R16, 10       ;compare R16 with 10
    BRMI  dsp           ;jump when R16 < 10
    INC   R23           ;increment counter2 by 1
    SUBI  R16, 10       ;R16 = R16 - 10
    RJMP  l8
    ;-----------------------------------------------------------------
dsp:PUSH  R16           ;save a copy of R16 in STACK
    ADD   R25, R19      ;MSD in ASCII dec
    MOV   R16, R25
    RCALL data_wrt      ;display MSD on LCD
    ;-----------------------------------------------------------------
    MOV   R16, R23      ;mid digit in ASCII dec
    ADD   R16, R19
    RCALL data_wrt      ;display mid digit on LCD
    ;-----------------------------------------------------------------
    POP   R16           ;get back from STACK stored copy of R16
    ADD   R16, R19      ;LSD in ASCII dec
    RCALL data_wrt      ;display LSD on LCD

    LDI   R16, 0x20
    RCALL data_wrt      ;display LSD on LCD

    LDI   R16, 0x43
    RCALL data_wrt      ;display LSD on LCD
    LDI   R16, 0xC0     ;cursor beginning of 2nd line
    RCALL command_wrt
    RCALL delay_ms

    RCALL disp_msg1      ;display message on 1st line

    LDI   R16, 0x20
    RCALL data_wrt      ;display LSD on LCD

    LDI   R16, 50     ;get high-byte result from ADCH    
    ;----------------------------------------------------------------
    CLR   R25           ;set counter1, initial value 0
    CLR   R23           ;set counter2, initial value 0
    ;----------------------------------------------------------------
    CPI   R16, 228      ;compare R16 with 228

    ;----------------------------------------------------------------
l9: CPI   R16, 100      ;compare R16 with 100
Ret1:BRMI  l10            ;jump when R16 < 100
    INC   R25           ;increment counter1 by 1
    SUBI  R16, 100      ;R16 = R16 - 100
    RJMP  l9
    ;-----------------------------------------------------------------
l10: CPI   R16, 10       ;compare R16 with 10
    BRMI  dsp1           ;jump when R16 < 10
    INC   R23           ;increment counter2 by 1
    SUBI  R16, 10       ;R16 = R16 - 10
    RJMP  l10
    ;-----------------------------------------------------------------
dsp1:PUSH  R16           ;save a copy of R16 in STACK
    ADD   R25, R19      ;MSD in ASCII dec
    MOV   R16, R25
    RCALL data_wrt      ;display MSD on LCD
    ;-----------------------------------------------------------------
    MOV   R16, R23      ;mid digit in ASCII dec
    ADD   R16, R19
    RCALL data_wrt      ;display mid digit on LCD
    ;-----------------------------------------------------------------
    POP   R16           ;get back from STRACK stored copy of R16
    ADD   R16, R19      ;LSD in ASCII dec
    RCALL data_wrt      ;display LSD on LCD

    LDI   R16, 0x20
    RCALL data_wrt      ;display LSD on LCD

    LDI   R16, 0x25
    RCALL data_wrt      ;display LSD on LCD

    RET

;=====================================================================
adjust:
    CPI   R16, 128      ;compare R16 with 128 when R16 >= 228
    RJMP  Ret

;==============================================================
binary2decimal:
;--------------
      CLR   R26             ;set counter1, initial value 0
      CLR   R27             ;set counter2, initial value 0
      ;--------------------------------------------------------
l70:  CPI   R28, 100        ;compare R28 with 100
Ret2:  BRMI  l80             ;jump when R28 < 100
      INC   R26             ;increment counter1 by 1
      SUBI  R28, 100        ;R28 = R28 - 100
      RJMP  l70
      ;--------------------------------------------------------
l80:  CPI   R28, 10         ;compare R28 with 10
      BRMI  dsp2             ;jump when R28 < 10
      INC   R27             ;increment counter2 by 1
      SUBI  R28, 10         ;R28 = R28 - 10
      RJMP  l80
      ;--------------------------------------------------------  
dsp2:  
      ;MOV   R18, R27
      ;MOV   R17, R29        ;select digit
      ; RCALL encrypt      ;send command & data to MAX7219
      ;--------------------------------------------------------
      MOV   R18, R28
      MOV   R17, R30        ;select digit
      RCALL encrypt      ;send command & data to MAX7219    
      ;--------------------------------------------------------
      RET
      
      
check_temperature:
    CPI R16, 22
    BRLO relay_toggle_off
    RET

check_water_lvl:
    CPI R16, 22
    BRLO buzzer_toggle_off
    RET



buzzer_toggle_on:
    SBI   PORTB, 1
    RET

buzzer_toggle_on:
    CBI  PORTB, 1
    RET

relay_toggle_on:
    SBI   PORTB, 3
    RET

relay_toggle_on:
    CBI  PORTB, 3
    RET
