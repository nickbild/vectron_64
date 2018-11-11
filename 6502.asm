;;;;
; Test LCD character display on custom 6502 computer.
;
; Reserved memory:
; $0000 - LCD enable
; $0001 - LCD disable
;;;;

		processor 6502

; Start at beginning of ROM.

		ORG $8000

		jsr InitLcd

; Set Address to position on line 1.
Start		lda #$80
		jsr LcdCePulse
		lda #$50
		jsr LcdCePulse

; H
		lda #$48		; 01001000 - data 0100, RS 1
		jsr LcdCePulse
		lda #$88
		jsr LcdCePulse
; E
		lda #$68
		jsr LcdCePulse
		lda #$58
		jsr LcdCePulse
; L
		lda #$68
		jsr LcdCePulse
		lda #$C8
		jsr LcdCePulse
; L
		lda #$68
		jsr LcdCePulse
		lda #$C8
		jsr LcdCePulse
; O
		lda #$68
		jsr LcdCePulse
		lda #$F8
		jsr LcdCePulse
; ,
		lda #$28
		jsr LcdCePulse
		lda #$C8
		jsr LcdCePulse

; Set Address to position on line 2.
		lda #$C0
		jsr LcdCePulse
		lda #$50
		jsr LcdCePulse

; 6
		lda #$38
		jsr LcdCePulse
		lda #$68
		jsr LcdCePulse
; 5
		lda #$38
		jsr LcdCePulse
		lda #$58
		jsr LcdCePulse
; 0
		lda #$38
		jsr LcdCePulse
		lda #$08
		jsr LcdCePulse
; 2
		lda #$38
		jsr LcdCePulse
		lda #$28
		jsr LcdCePulse
; !
		lda #$28
		jsr LcdCePulse
		lda #$18
		jsr LcdCePulse

Idle		jmp Idle

Delay		ldx #$FF
DelayLoop1	ldy #$FF
DelayLoop2	dey
		bne DelayLoop2
		dex
		bne DelayLoop1
		rts

DelayShort	ldx #$80
DelayShortLoop1	dex
		bne DelayShortLoop1
		rts

; Send high pulse to LCD enable pin.
LcdCePulse	sta $01
		jsr DelayShort
		sta $00
		jsr DelayShort
		sta $01
		jsr DelayShort
		rts

; LCD initialization sequence.
InitLcd		jsr Delay

		lda #$30		; 00110000 - data 0011, RS 0
		jsr LcdCePulse
		jsr Delay
		lda #$30
		jsr LcdCePulse
		jsr Delay
		lda #$30
		jsr LcdCePulse
		lda #$20
		jsr LcdCePulse
		jsr DelayShort

; Set 8 bit, 2 line, 5x8.
		lda #$20
		jsr LcdCePulse
		lda #$80
		jsr LcdCePulse

; Display on.
		lda #$00
		jsr LcdCePulse
		lda #$C0
		jsr LcdCePulse

; Clear display.
		lda #$00
		jsr LcdCePulse
		lda #$10
		jsr LcdCePulse
		jsr Delay

; Entry mode.
		lda #$00
		jsr LcdCePulse
		lda #$60
		jsr LcdCePulse

		rts

