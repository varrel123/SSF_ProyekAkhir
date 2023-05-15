#define __SFR_OFFSET 0x00
#include "avr/io.h"

.global main
main:
  SBI DDRD, 2
  CBI DDRD, 3
  SBI DDRD, 4
  SBI DDRD, 5
  CBI DDRD, 6
  SBI PORTD, 6
  CBI DDRD, 7
  SBI   DDRB, 1         ;pin PB1 as o/p (Trigger)
  CBI   DDRB, 0         ;pin PB0 as i/p (Echo)
  RCALL init_serial
  sei
loop:
  SBIS PIND, 6
  SBI PIND, 4
  SBIC PIND, 3
  RCALL mesin_nyala
  SBIS PIND, 3
  RCALL mati
  RCALL LCD_buffer ;Subroutine untuk mengecek Flag UDRE0
  LDI R26, 0x0A
  STS UDR0, R26 ;print newline
  RCALL LCD_buffer ;Subroutine untuk mengecek Flag UDRE0
  LDI R26, 0x0D
  STS UDR0, R26 ;print carriage return
  RCALL delay_ms
  RJMP  loop

init_serial:
  CLR R24 ; Meng-clear R24 untuk meng-clear UCSR0A dan UBRR0H
  STS UCSR0A, R24 ; Menyimpan isi dari R24 yang sudah di-clear ke UCSR04
  STS UBRR0H, R24 ; Menyimpan isi dari R24 yang sudah di-clear ke UBRR0H
  LDI R24, 103 ; Mengisi R24 untuk mengisi UBRR0L
  STS UBRR0L, R24 ; Menetapkan baud rate dengan menyimpan isi dari R24
  LDI R24, 1<<RXEN0 | 1<<TXEN0 ; Meng-enable RXB dan TXB
  STS UCSR0B, R24 ; Menyimpan isi dari R24
  LDI R24, 1<<UCSZ00 | 1<<UCSZ01 ; Async, no parity, 1 stop, 8 bits
  STS UCSR0C, R24; Menyimpan isi dari R24
  RET

mesin_nyala:
  SBIC PIND, 7
  BREQ siang
  RCALL malam
  RET

siang:
  CBI PORTD, 5
  CBI PORTD, 2
  LDI R30, lo8(message_siang) ; Me-load low-byte dari pesan yang diinginkan ke Z
  LDI R31, hi8(message_siang) ; Me-load high-byte dari pesan yang diinginkan ke Z
  RCALL agn
  RET

malam:
  SBI   PORTB, 1
  RCALL delay_timer0
  CBI   PORTB, 1        ;send 10us high pulse to sensor
  RCALL echo_PW         ;compute Echo pulse width count
  RCALL byte2decimal    ;covert & display on serial
  CPI R27, 1
  BRSH terang
  CPI R27, 0
  BREQ redup
  RET

terang:
  SBI PORTD, 5
  SBI PORTD, 2
  LDI R30, lo8(message_terang) ; Me-load low-byte dari pesan yang diinginkan ke Z
  LDI R31, hi8(message_terang) ; Me-load high-byte dari pesan yang diinginkan ke Z
  RCALL agn
  RET
redup:
  SBI PORTD, 5
  CBI PORTD, 2
  LDI R30, lo8(message_redup) ; Me-load low-byte dari pesan yang diinginkan ke Z
  LDI R31, hi8(message_redup) ; Me-load high-byte dari pesan yang diinginkan ke Z
  RCALL agn
  RET
mati:
  CBI PORTD, 5
  CBI PORTD, 2
  LDI R30, lo8(message_mesin) ; Me-load low-byte dari pesan yang diinginkan ke Z
  LDI R31, hi8(message_mesin) ; Me-load high-byte dari pesan yang diinginkan ke Z
  RCALL agn
  RET

agn:
  LPM R29, Z+ ; Me-load satu char dari strings yang disimpan di program memory Z
  CPI 29, 0 ; Meng-compare apakah R19 berisi 0
  BREQ ext ; Jika nol, program akan branch ke ext
  RCALL LCD_buffer
  STS UDR0, R29 ; Menyimpan char ke  UDR0 yang akan ditampilkan di serial monitor
  RJMP agn ; kembali ke agn sampai R19 bernilai 0
ext:
  RET

message_mesin:
  .ascii "Mesin Mati..." ; Pesan yang diinginkan
  .byte 0

message_siang:
  .ascii "Siang hari, lampu mati..." ; Pesan yang diinginkan
  .byte 0

message_terang:
  .ascii "Malam hari, tidak ada mobil di depan, lampu menyala terang..." ; Pesan yang diinginkan
  .byte 0

message_redup:
  .ascii "Malam hari, ada mobil di depan, lampu menyala redup...." ; Pesan yang diinginkan
  .byte 0
echo_PW:
;-------
    LDI   R20, 0b00000000
    STS   TCCR1A, R20     ;Timer 1 normal mode
    LDI   R20, 0b11000101 ;set for rising edge detection &
    STS   TCCR1B, R20     ;prescaler=1024, noise cancellation ON
    ;-----------------------------------------------------------
l1: IN    R21, TIFR1
    SBRS  R21, ICF1
    RJMP  l1              ;loop until rising edge is detected
    ;-----------------------------------------------------------
    LDS   R16, ICR1L      ;store count value at rising edge
    ;-----------------------------------------------------------
    OUT   TIFR1, R21      ;clear flag for falling edge detection
    LDI   R20, 0b10000101
    STS   TCCR1B, R20     ;set for falling edge detection
    ;-----------------------------------------------------------
l2: IN    R21, TIFR1
    SBRS  R21, ICF1
    RJMP  l2              ;loop until falling edge is detected
    ;-----------------------------------------------------------
    LDS   R28, ICR1L      ;store count value at falling edge
    ;-----------------------------------------------------------
    SUB   R28, R16        ;count diff R22 = R22 - R16
    OUT   TIFR1, R21      ;clear flag for next sensor reading
    RET

byte2decimal:
;------------
      CLR   R26             ;set counter1, initial value 0
      CLR   R27             ;set counter2, initial value 0
      ;--------------------------------------------------------
l70:  CPI   R28, 100        ;compare R28 with 100
Ret:  BRMI  l80             ;jump when R28 < 100
      INC   R26             ;increment counter1 by 1
      SUBI  R28, 100        ;R28 = R28 - 100
      RJMP  l70
      ;--------------------------------------------------------
l80:  CPI   R28, 10         ;compare R28 with 10
      BRMI  dsp             ;jump when R28 < 10
      INC   R27             ;increment counter2 by 1
      SUBI  R28, 10         ;R28 = R28 - 10
      RJMP  l80
      ;--------------------------------------------------------  
dsp:  
  RET

delay_ms:
;--------
ldi r25, hi8(500) ; Memasukkan nilai delay dalam satuan ms ke r25
  ldi r24, lo8(500) ; Memasukkan nilai delay dalam satuan ms ke r24
outerLoop:
; karena innerLoop berjalan selama 4 cycle, maka di-loop 4000x sehingga menghasilkan
; 1 millisecond (4 x 4000 : 16Mhz = 10^-3)
  ldi r31, hi8(4000) ; mengisi r30 dan r31 dengan 4000
  ldi r30, lo8(4000)
innerLoop:
  sbiw r30,1 ; Mengurangi isi r30 dan r31 sebanyak 1
  brne innerLoop ; Jika hasil pengurangan baris sebelumnya tidak menghasilkan nol,
; innerLoop akan terus diulang
;------------------------------(end of innerLoop)
  
  sbiw r24, 1 ; Mengurangi r24 dan r25 sebanyak 1
  brne outerLoop; Jika hasil pengurangan baris sebelumnya tidak menghasilkan nol,
; maka outerLoop akan terus diulang dan innerLoop akan dijalankan kembali
RET

LCD_buffer:
  LDS R17, UCSR0A
  SBRS R17, UDRE0 ;test data buffer if data can be sent
  RJMP LCD_buffer
  RET

delay_timer0:             ;10 usec delay via Timer 0
;------------
    CLR   R20
    OUT   TCNT0, R20      ;initialize timer0 with count=0
    LDI   R20, 20
    OUT   OCR0A, R20      ;OCR0 = 20
    LDI   R20, 0b00001010
    OUT   TCCR0B, R20     ;timer0: CTC mode, prescaler 8
    ;-----------------------------------------------------------
l0: IN    R20, TIFR0      ;get TIFR0 byte & check
    SBRS  R20, OCF0A      ;if OCF0=1, skip next instruction
    RJMP  l0              ;else, loop back & check OCF0 flag
    ;-----------------------------------------------------------
    CLR   R20
    OUT   TCCR0B, R20     ;stop timer0
    ;-----------------------------------------------------------
    LDI   R20, (1<<OCF0A)
    OUT   TIFR0, R20      ;clear OCF0 flag
    RET