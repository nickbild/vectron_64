;;;;
; Test LCD character display on custom 6502 computer.
;
; Reserved memory:
; $0000 - LCD enable
; $0001 - LCD disable
; $7FC0-$7FFF - Data to write to LCD.
;;;;

		processor 6502

; Start at beginning of ROM.

		ORG $8000

		jsr InitLcd
		jsr ZeroLCDRam

; Load memory with contents to write to LCD.

		lda #$48
		sta $7FC0
		lda #$88
		sta $7FC1
		
		lda #$68
		sta $7FC2
		lda #$58
		sta $7FC3

		lda #$68
		sta $7FC4
		lda #$C8
		sta $7FC5

		lda #$68
		sta $7FC6
		lda #$C8
		sta $7FC7

		lda #$68
		sta $7FC8
		lda #$F8
		sta $7FC9

		lda #$28
		sta $7FCA
		lda #$C8
		sta $7FCB


		lda #$38
		sta $7FE0
		lda #$68
		sta $7FE1
		
		lda #$38
		sta $7FE2
		lda #$58
		sta $7FE3

		lda #$38
		sta $7FE4
		lda #$08
		sta $7FE5

		lda #$38
		sta $7FE6
		lda #$28
		sta $7FE7

		lda #$28
		sta $7FE8
		lda #$18
		sta $7FE9

; Write to LCD.

		jsr WriteLCD

Idle		jmp Idle

;;;
; Long Delay
;;;

Delay		ldx #$FF
DelayLoop1	ldy #$FF
DelayLoop2	dey
		bne DelayLoop2
		dex
		bne DelayLoop1
		rts

;;;
; Short Delay
;;;

DelayShort	ldx #$80
DelayShortLoop1	dex
		bne DelayShortLoop1
		rts

;;;
; Send high pulse to LCD enable pin.
;;;

LcdCePulse	sta $01
		jsr DelayShort
		sta $00
		jsr DelayShort
		sta $01
		jsr DelayShort
		rts

;;;
; LCD initialization sequence.
;;;

InitLcd		jsr Delay

		lda #$30			; 00110000 - data 0011, RS 0
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

;;;
; Write LCD-reserved RAM addresses to LCD.
;;;

WriteLCD	lda #$80		; Line 1 : 1000 (line1) 0000 (RS 0)
 		jsr LcdCePulse
		lda #$00		; Position 0 : 0000 (position 0) 0000 (RS 0)
		jsr LcdCePulse

		ldy #$00
Line1Loop	lda $7FC0,y
		jsr LcdCePulse
		iny
		cpy #$20
		bcc Line1Loop

		lda #$C0		; Line 2 : 1100 (line2) 0000 (RS 0)
 		jsr LcdCePulse
		lda #$00		; Position 0 : 0000 (position 0) 0000 (RS 0)
		jsr LcdCePulse

		ldy #$00
Line2Loop	lda $7FE0,y
		jsr LcdCePulse
		iny
		cpy #$20
		bcc Line2Loop

		rts

;;;
; Zero out LCD reserved RAM (set all positions to space character).
;;;

ZeroLCDRam	ldx #$00
ZeroLoop	lda #$28
		sta $7FC0,x
		inx
		lda #$08
		sta $7FC0,x
		inx
		cpx #$40
		bcc ZeroLoop

		rts

