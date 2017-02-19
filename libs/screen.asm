;Macros, subroutines, and constants for manipulating the screen.

	screencols=40		;Number of character columns.
	screenrows=20		;Number of character rows.
	screen=$0400		;Address for screen 40x25 characters.
	colors=$d800		;Address for screen 40x25 colors.
	pixels=$1000		;Address for pixels.
	screencon=$d016		;Address for screen control.
	customchar=$d018	;Address for custom character set.
	multicolbit=$10		;Mask bit for multicolor mode.
	bdcolor=$d020		;Address for border color.
	bgcolor=$d021		;Address for background color.
	mccolor1=$d022		;Address for multicolor 1.
	mccolor2=$d023		;Address for multucolor 2.
	rasterlinel=$d011	;Address for current raster line (low byte).
	rasterlineh=$d012	;Address for current raster line (high byte).
	clrscreen=$e544		;Address of clear screen subroutine.

!macro draw_text .text, .textlen, .x, .y {
		.offset=screen+.x+.y*$28
		ldx #$00		;Initialize x register.
		.loop
		lda .text,x		;Load character from text offset by X.
		sta .offset,x		;Put character on screen offset by X.
		inx			;Increment X.
		cpx #.textlen		;Compare X with text length.
		bne .loop		;Repeat loop until end of text.
		}

!macro draw_tile .tiles, .attribs, .write_offset, .tile_size {
		;Layout of tile .is:
		;   ...ABCD...
		;and layout of tile on screen .is
		;   ...AB...
		;   ...CD...
		;
		tya
		asl
		tay

		lda .attribs, x

		!for .i, .tile_size {
		!for .j, .tile_size {
		sta colors + .write_offset + screencols * (.j-1) + (.i-1), y
		}
		}

		txa
		asl
		asl
		tax
		bcs .carry
	
		!for .i, .tile_size {
		!for .j, .tile_size {
		lda .tiles + (.i-1) + (.j-1) * .tile_size, x
		sta screen + .write_offset + (.i-1) + (.j-1) * screencols, y
		}
		}
		jmp .done
	
	.carry
		!for .i, .tile_size {
		!for .j, .tile_size {
		lda .tiles + 256 + (.i-1) + (.j-1) * .tile_size, x
		sta screen + .write_offset + (.i-1) + (.j-1) * screencols, y
		}
		}
	
	.done
		tya
		lsr
		tay
}

!macro draw_map .map, .tiles, .attribs, .tile_size, .map_width, .map_height {
;Loop over each tile, drawing .its tile .info on screen.
;Assumes at least .tile_size >= 2.
	!for .row, .map_height {
		ldy #$00
	-
		;Read tile ID from map.
		ldx .map + .map_width*(.row-1), y
		+draw_tile .tiles, .attribs, 80*(.row-1), .tile_size
		iny
		cpy #.map_width
		bcc -
	}

	.done
}

!macro set_color .color, .x, .y {
		.offset=colors+.x+.y*$28
		lda #.color
		sta .offset
		}

!macro set_mc_color .color1, .color2 {
		+set_mc_color_1 .color1
		+set_mc_color_2 .color2
		}

!macro set_mc_color_1 .color {
		lda #.color
		sta mccolor1
		}

!macro set_mc_color_2 .color {
		lda #.color
		sta mccolor2
		}

!macro set_mc_color_3 .color {
		lda #.color
		sta $d024
		}

!macro set_bd_color .color {
		lda #.color
		sta bdcolor
		}

!macro set_bg_color .color {
		lda #.color
		sta bgcolor
		}

!macro set_colors .color, .width, .x, .y {
		.offset=colors+.x+.y*$28
		ldx #$00		;Initialize x register.
	.loop
		lda .color		;Load color from colors offset by X.
		sta .offset,x		;Put color on screen offset by X.
		inx			;Increment X.
		cpx #.width		;Compare X with width.
		bne .loop		;Repeat loop until end of width.
		}

!macro enable_multicolor {
		lda screencon
		ora #multicolbit
		sta screencon
		}

!macro set_char_loc .offset {
		lda customchar
		ora #.offset
		sta customchar
		}

