;;;;
; Operating system for a custom 6502 computer.
; Nick Bild - nick.bild@gmail.com
; https://github.com/nickbild/6502_os
;
; Reserved memory:
; $0000 - LCD enable
; $0001 - Unused -- read it to disable any IC (except RAM).
; $0100-$01FF - 6502 stack
; $7FC0-$7FFF - Data to write to LCD.
;               Each character (16 x 2 lines) is represented by
;               2 consecutive bytes (4-bit mode).
;               Most sig. 4 bits are for LCD data.
;               Least sig. 4 bits - only bit 3 used (tied to RS pin).
;
; $FFF8 - Clock keyboard shift register and enable line buffer.
; $FFF9 - Reset binary counter (counts bits received from PS/2 keyboard packets).
;
; $FFFA - NMI IRQ Vector
; $FFFB - NMI IRQ Vector
; $FFFC - Reset Vector - Stores start address of this ROM.
; $FFFD - Reset Vector
; $FFFE - IRQ Vector - Keyboard ISR address.
; $FFFF - IRQ Vector
;;;;

		processor 6502

; Start at beginning of ROM.
StartExe	ORG $8000
		sei

		jsr InitLcd
		jsr ZeroLCDRam

; Discard keyboard initialization sequence, then enable interrupts.
		;jsr SkipKeyboardInit
		jsr Delay
		jsr ResetKeyboardCounter
		cli

MainLoop	;jsr WriteLCD
		jmp MainLoop

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

;;;
; Reset binary counter tracking receipt of complete packets from keyboard.
;;;

ResetKeyboardCounter
		lda $0001
		lda $FFF9
		lda $0001

		rts

;;;
; Read in all of the initialization data from the keyboard and discard it.
;;;

SkipKeyboardInit
		ldy #$00
KBInitLoop	jsr ResetKeyboardCounter
		jsr DelayShort
		iny
		cpy #$20
		bcc KBInitLoop

		rts

;;;
; Keyboard Interrupt Service Routine.
;;;

KbIsr
		pha
		.byte #$DA ; phx - mnemonic unknown to DASM.

		; Display shift register contents on output pins,
		; and enable line buffer.
		; Read shift register contents into accumulator.
		lda $FFF8

		; Skip key up scan codes.
		cmp #$F0
		beq SkipScanCode

		; Convert scan code into LCD code.
		sbc #$14
		tax
		lda ScanCodeLookup,x

		; Store data in memory location read by LCD.
		sta $7FC0
		sta $7FC1

		; Make sure RS (bit 3) is set to 1.
		lda #$0F
		ora $7FC0
		sta $7FC0

		; Move least sig. nibble to most sig. position, then make sure RS is 1.
		rol $7FC1
		rol $7FC1
		rol $7FC1
		rol $7FC1
		lda #$0F
		ora $7FC1
		sta $7FC1

		jsr WriteLCD

		; Finished ISR, reset binary counter.
SkipScanCode
		lda $FFF9
		lda $0001

		.byte #$FA ; plx
		pla

		rti

; PS/2 Code Set 2 Scan Code Lookup Table
; Subtract $14 from scan code to determine
; byte offset into this table.
; Value at lookup location is character
; LCD data corresponding to scan code.
ScanCodeLookup
		.byte #$51	; Q
		.byte #$31	; 1
		.byte #$00	; unused
		.byte #$00	; unused
		.byte #$00	; unused
		.byte #$5A	; Z
		.byte #$53	; S
		.byte #$41	; A
		.byte #$57	; W
		.byte #$32	; 2
		.byte #$00	; unused
		.byte #$00	; unused
		.byte #$43	; C
		.byte #$58	; X
		.byte #$44	; D
		.byte #$45	; E
		.byte #$34	; 4
		.byte #$33	; 3
		.byte #$00	; unused
		.byte #$00	; unused
		.byte #$00	; <space>
		.byte #$56	; V
		.byte #$46	; F
		.byte #$54	; T
		.byte #$52	; R
		.byte #$35	; 5
		.byte #$00	; unused
		.byte #$00	; unused
		.byte #$4E	; N
		.byte #$42	; B
		.byte #$48	; H
		.byte #$47	; G
		.byte #$59	; Y
		.byte #$36	; 6
		.byte #$00	; unused
		.byte #$00	; unused
		.byte #$00	; unused
		.byte #$4d	; M
		.byte #$4a	; J
		.byte #$55	; U
		.byte #$37	; 7
		.byte #$38	; 8
		.byte #$00	; unused
		.byte #$00	; unused
		.byte #$2C	; ,
		.byte #$4B	; K
		.byte #$49	; I
		.byte #$4F	; O
		.byte #$30	; 0
		.byte #$39	; 9
		.byte #$00	; unused
		.byte #$00	; unused
		.byte #$2E	; .
		.byte #$2F	; /
		.byte #$4C	; L
		.byte #$3B	; ;
		.byte #$50	; P
		.byte #$2D	; -
		.byte #$00	; unused
		.byte #$00	; unused
		.byte #$00	; unused
		.byte #$27	; '
		.byte #$00	; unused
		.byte #$5B	; [
		.byte #$3D	; =
		.byte #$00	; unused
		.byte #$00	; unused
		.byte #$00	; unused
		.byte #$00	; unused
		.byte #$00	; <enter>

; Store the location of key program sections.
		ORG $FFFC
ResetVector
		.word StartExe		; Start of execution.
IrqVector
		.word KbIsr				; Interrupt service routine.
