;Macros, subroutines, and constants for manipulating interrupts.

	timer1=$dc0d		;Address of CIA timer 1.
	timer2=$dd0d		;Address of CIA timer 2.
	rastermask=$d01a	;Address of raster interrupt mask.
	rasterbit=$01		;Mask bit for raster.
	rasterirql=$314		;Address of raster interrupt vector (low byte).
	rasterirqh=$315		;Address of raster interrupt vector (high byte).
	systemirq=$ea31		;Address of system IRQ routine.
	rstrlinel=$d012		;Address for IRQ raster line (low byte).
	rstrlineh=$d011		;Address for IRQ raster line (high byte).
	irqregister=$d019	;Address for source of IRQ.

!macro disable_timers {
	lda #$7f
	sta timer1
	sta timer2
}

!macro enable_raster_irq {
	lda rastermask
	ora #rasterbit
	sta rastermask
}

!macro set_raster_irq_line .line {
	;For now, don't worry about high bit.
	;Clear high bit of raster line.
	lda rstrlineh
	and #$7f
	sta rstrlineh

	;Set low byte to line number.
	lda #.line
	sta rstrlinel
}

!macro clear_irq_source {
	dec irqregister
}

