;Macros, subroutines, and constants for manipulating the screen.

	screen=$0400		;Address for screen 40x25 characters.
	colors=$D800		;Address for screen 40x25 colors.
	pixels=$1000		;Address for pixels.
	bdcolor=$d020		;Address for border color.
	bgcolor=$d021		;Address for background color.
	rasterlinel=$d011	;Address for current raster line (low byte).
	rasterlineh=$d012	;Address for current raster line (high byte).
	clrscreen=$e544		;Address of clear screen subroutine.

!macro draw_text .text, .textlen, .x, .y {
	.offset=screen+.x+.y*$28
	ldx #$00		;Initialize x register.
.loop	lda .text,x		;Load character from text offset by X.
	sta .offset,x		;Put character on screen offset by X.
	inx			;Increment X.
	cpx #.textlen		;Compare X with text length.
	bne .loop		;Repeat loop until end of text.
}

!macro set_color .color, .x, .y {
	.offset=colors+.x+.y*$28
	lda .color
	sta .offset
}

!macro set_colors .color, .width, .x, .y {
	.offset=colors+.x+.y*$28
	ldx #$00		;Initialize x register.
.loop	lda .color		;Load color from colors offset by X.
	sta .offset,x		;Put color on screen offset by X.
	inx			;Increment X.
	cpx #.width		;Compare X with width.
	bne .loop		;Repeat loop until end of width.
}
