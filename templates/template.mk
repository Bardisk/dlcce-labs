TNAME ?= $(basename $(notdir $(shell find *.sv | grep -v tb)))

compile: build/wave.vcd
	@echo "Compile done!"

run: compile
	@gtkwave build/wave.vcd

build/wave.vcd: $(TNAME).sv $(TNAME)_tb.sv
	@if ! [ -e build ]; then mkdir build; fi;
	@iverilog -I include/ $(TNAME)_tb.sv -o build/$(TNAME).vexe
	@./build/$(TNAME).vexe

clean:
	-@if [ -e build ]; then rm -r build; fi;

create:
	@if ! [ -e include ]; then mkdir include; fi;
	@mkdir include/$(NAME)
	@cp .svlint.toml include/$(NAME)/
	@cat ../templates/template_submodule.sv >include/$(NAME)/$(NAME).sv
	@cat ../templates/template_submodule_tb.sv >include/$(NAME)/$(NAME)_tb.sv
	@sed -i 's/template.sv/$(TNAME).sv/g' include/$(NAME)/$(NAME)_tb.sv
	@sed -i 's/template/$(NAME)/g' include/$(NAME)/$(NAME).sv include/$(NAME)/$(NAME)_tb.sv
	@sed -i '/\/\/add includes here/i\`include "$(NAME)/$(NAME).sv"' $(TNAME).sv

unit:
	@if ! [ -e build ]; then mkdir build; fi;
	@iverilog -I include/ include/$(NAME)/$(NAME)_tb.sv -o build/$(NAME).vexe
	@./build/$(NAME).vexe

.PHONY: clean create compile run unit
