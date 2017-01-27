;Hello World Example Project
;
;Boot loader
!source "loader.asm"
+start_at $1000

;Iterates over "HELLO WORLD!"  message, assigning characters to
;screen memory until end of message.
	;*=$1000		;Set program counter.

	screen=$0400	;Memory address for screen.
	messagelen=12	;Number of characters in message.
	toupper=$3f	;Bits to set character to uppercase.

	ldx #$00	;Set X register to 0.
loop	lda message,x	;Load character from message offset by X.
	and #toupper	;Ensure character is uppercase.
	sta screen,x	;Put character on screen offset by X.
	inx		;Increment X.
	cpx #messagelen	;Compare X with message length.
	bne loop	;Repeat loop until end of message.
	rts		;Return subroutine.
	
message !scr "HELLO WORLD!"

