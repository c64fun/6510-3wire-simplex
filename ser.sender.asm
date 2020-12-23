;name:    ser.sender.src
;date:    october 11th 1989
;author:  oliver kaltstein

;version: V1   (this version doesn't need ram)
;              (achtung: sp wird als zwischenspeicher
;               missbraucht!)

;preparation: load accu with character,
;             position-counter x will be saved.

; INPUT 64 6/86  INPUT-ASS, 6502/6510 Macro-Assembler 

org$e000

:direction = 56579
:port      = 56577


:start     sei
           clc
           cld
           ldx #00
           jmp readdata
:text      b "Hello World! "
:readdata  lda text,x
           inx
           txs               ;ser.sender starts here
           ldx #07
           stx direction     ;p0 to p2 are outputs
           ldx #04
           stx port          ;set ATN
           tax 
           ldy #08
:loop1     clc
           txa               ;saved data back into accu
           rol
           bcs sendhigh      ;if msb is one it will be send as high
:sendlow   ldx #06           ;set data low & clock high
           stx port
           nop
           nop
           nop
           jmp cont
:sendhigh  ldx #05
           stx port          ;set data high but clock low
           nop
           nop
           nop
           ldx #07
           stx port          ;put clock high
:cont      jmp wait1
:endwait1  ldx #04
           stx port          ;clk back to low
           jmp wait2
:endwait2  dey
           tax               ;save databyte in x-register
           tya               ;counter has to be in accu to be tested
           bne loop1
           ldx #00           ;end off byte, all lines low
           stx port
           jmp wait3         ;delay allows receiver to syncronize if byte lost
:endwait3  tsx               ;saved counterbyte back into x-register
           cpx #38
           bne readdata
           jmp start

:wait1     s $800            ;2Kspace for nops, please replace zeros with nops
           jmp endwait1      ;because compiler can't fill with nops.
:wait2     s $800
           jmp endwait2
:wait3     s $800
           jmp endwait3
