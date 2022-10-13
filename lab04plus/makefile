TNAME ?= $(basename $(notdir $(shell find $(DIR) -regex ".*\.sv" | grep -v tb)))

$(TNAME)_wave.vcd: $(TNAME).sv $(TNAME)_tb.sv
	@iverilog $(TNAME).sv $(TNAME)_tb.sv -o $(TNAME).out
	@./$(TNAME).out
	@gtkwave $(TNAME)_wave.vcd

clean:
	-@rm *.out
	-@rm *.vcd

create:
	@mkdir $(NAME)
	@cp makefile $(NAME)/
	@cp .gitignore $(NAME)/
	@cat template.sv >$(NAME)/$(NAME).sv
	@cat template_tb.sv >$(NAME)/$(NAME)_tb.sv
	@sed -i 's/template/$(NAME)/g' $(NAME)/$(NAME).sv $(NAME)/$(NAME)_tb.sv
.PHONY: create
