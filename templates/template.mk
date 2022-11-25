TNAME ?= $(basename $(notdir $(shell find *.sv | grep -v tb)))

SUBDIR = include/$(NAME)

compile: build/wave.vcd
	@echo "Compile finished!"

pre-compile: compile
	@if ! [ -e build ]; then mkdir build; fi;
	@iverilog -o build/$(TNAME)_pre.sv -E -I include/ $(TNAME).sv

run: compile
	@gtkwave build/wave.vcd

build/wave.vcd: $(TNAME).sv $(TNAME)_tb.sv
	@if ! [ -e build ]; then mkdir build; fi;
	@iverilog -o build/$(TNAME).vexe -I include/ $(TNAME)_tb.sv
	@vvp ./build/$(TNAME).vexe

clean:
	-@if [ -e build ]; then rm -r build; fi;

create:
	@if ! [ -e include ]; then mkdir include; fi;
	@mkdir $(SUBDIR)
	@cat ../../templates/template_submodule.sv >$(SUBDIR)/$(NAME).sv
	@cat ../../templates/template_submodule_tb.sv >$(SUBDIR)/$(NAME)_tb.sv
	@sed -i 's/template.sv/$(TNAME).sv/g' $(SUBDIR)/$(NAME)_tb.sv
	@sed -i 's/template/$(NAME)/g' $(SUBDIR)/$(NAME).sv $(SUBDIR)/$(NAME)_tb.sv
	@sed -i '/\/\/add includes here/i\`include "$(NAME)/$(NAME).sv"' $(TNAME).sv

lsmod:
	@ls ../../libs

unit:
	@if ! [ -e build ]; then mkdir build; fi;
	@iverilog -o build/$(NAME).vexe -I include/ include/$(NAME)/$(NAME)_tb.sv
	@vvp ./build/$(NAME).vexe

immod:
	@if ! [ -e include ]; then mkdir include; fi;
	@cp -a ../../libs/$(MOD) ./include/
	@sed -i '/\/\/add includes here/i\`include "$(MOD)/$(MOD).sv"' $(TNAME).sv

exmod:
	@cp -a ./include/$(MOD) ../../libs/

.PHONY: clean create compile run unit immod exmod
