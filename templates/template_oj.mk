TNAME ?= $(basename $(notdir $(shell find *.sv | grep -v tb)))

compile: build/wave.vcd
	@echo "Compile done!"

run: compile
	@gtkwave build/wave.vcd

build/wave.vcd: $(TNAME).sv $(TNAME)_tb.sv
	@if ! [ -e build ]; then mkdir build; fi;
	@iverilog -o build/$(TNAME).vexe -I include/ $(TNAME)_tb.sv
	@vvp build/$(TNAME).vexe

clean:
	-@if [ -e build ]; then rm -r build; fi;

.PHONY: clean create compile run unit
