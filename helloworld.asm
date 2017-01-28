;Hello World Example Project

;Boot loader
!source "loader.asm"
+start_at $1000

;Screen utilities
!source "screen.asm"

;Initialization
	jmp init

;Iterates over "HELLO WORLD!"  message, assigning characters to
;screen memory until end of message.
message !scr "hello world!"
	messagelen=12	;Number of characters in message.

init	jsr clrscreen	;Clear screen
	ldx #$00	;Set X register to 0.
loop	lda message,x	;Load character from message offset by X.
	sta screen,x	;Put character on screen offset by X.
	inx		;Increment X.
	cpx #messagelen	;Compare X with message length.
	bne loop	;Repeat loop until end of message.
	rts		;Return subroutine.
	

