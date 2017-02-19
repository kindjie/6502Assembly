;Interrupts Example Project

* = $3800
chars
	!bin "./charsets/chars.raw",1960

* = $1600
tiles
	!bin "./charsets/tiles.raw", 1024

* = $2000
map
	!bin "./charsets/map.raw", 240

* = $2400
attribs
	!bin "./charsets/attribs.raw", 256

;Boot Loader
!source "./libs/loader.asm"
+start_at $c000		;4k free memory.

;Screen Utilities
!source "./libs/screen.asm"

;Interrupt Utilities
!source "./libs/interrupt.asm"

;Initialization
	raster_irq_line=$00
	jmp init

init	sei
	jsr clrscreen
	+disable_timers
	+enable_raster_irq
	+set_raster_irq_line raster_irq_line
	       
	lda #<irq
	sta rasterirql
	lda #>irq
	sta rasterirqh

	+set_char_loc $0e
	+enable_multicolor
	+set_mc_color 12, 15
	+set_bd_color 0
	+set_bg_color 11

	cli

run	
	jmp run			;Loop forever.

irq	+clear_irq_source
	+set_raster_irq_line raster_irq_line
	+draw_map map, tiles, attribs, 2, 20, 12
	jmp systemirq

