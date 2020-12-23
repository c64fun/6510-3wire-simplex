;name: ser.receive.src
;date: october 10th 1989
;author: oliver kaltstein

;purpose:  ser.receive displays the data
;          it receives through bit0 off
;          the parallel port as an ascii
;          on the screen using $ffd2.

; INPUT 64 6/86  INPUT-ASS, 6502/6510 Macro-Assembler 

org$c000

:direction = 56579
:port      = 56577
:buffer    = $fe
:chrout    = $ffd2


:start     lda #00
           sta direction
:loop1     lda port
           ror           ;shift atn into carry
           ror
           ror
           bcs loop1     ;wait for atn=0
:loop2     lda port
           ror
           ror
           ror
           bcc loop2     ;wait for atn=1
           ldx #00       ;erase received data
           ldy #08       ;read data 8 times
:loop3     lda port
           ror
           ror
           bcc loop3     ;wait for clk=1
           txa
           asl
           sta buffer
           lda port
           and #01       ;select data bit
           adc buffer
           tax
           lda port
           ror
           ror
           bcc error     ;if clk=0 then tv too short
:loop4     lda port
           ror
           ror
           bcs loop4     ;continue if data invalid
           dey
           tya
           bne loop3
           txa           ;put result into accu
           jsr chrout    ;print accu
           jmp start

:error     brk           ;increase tv off sender
