;Interrupts Example Project

;Boot Loader
!source "loader.asm"
+start_at $1000

;Screen Utilities
!source "screen.asm"

;Interrupt Utilities
!source "interrupt.asm"

;Initialization
	raster_irq_line=$00
	message_len=22
	jmp init

;Data
message	!scr "interrupts are awesome"

init	sei			;Disable interrupts while we setup.
	jsr clrscreen
	
	+disable_timers		;Disable Complex Interface Adapter IRQs (I/O and Timers).
	
	+enable_raster_irq	;Enable flag for raster interrupts, then set raster line.
	+set_raster_irq_line raster_irq_line
		
	lda #<irq		;Set low byte of interrupt vector.
	sta rasterirql
	lda #>irq		;Set high byte of interrupt vector.
	sta rasterirqh

	cli			;Reenable interrupts.

run	+draw_text message, message_len, 9, 12
	jmp run			;Loop forever.

irq	+clear_irq_source
	+set_raster_irq_line raster_irq_line
	inc bdcolor
	jmp systemirq

