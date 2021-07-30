C1541 ?= c1541
X64 ?= x64sc

.PRECIOUS: %.d64

%.prg: %.asm
	acme --cpu 6510 --format cbm --outfile $@ $<

%.d64: %.prg
	$(C1541) -format default,lodis d64 $@ -write $<

%: %.d64
	$(X64) $<

.PHONY: clean
clean:
	rm -f *.prg *.d64

