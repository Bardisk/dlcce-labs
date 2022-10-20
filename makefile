ID ?= 211240088

create:
	@mkdir $(NAME)
	@cat templates/template.mk >$(NAME)/makefile
	@cat templates/template.sv >$(NAME)/$(NAME).sv
	@cat templates/template_tb.sv >$(NAME)/$(NAME)_tb.sv
	@cp .gitignore $(NAME)/
	@cp .svlint.toml $(NAME)/
	@sed -i 's/template/$(NAME)/g' $(NAME)/$(NAME).sv $(NAME)/$(NAME)_tb.sv

submit:
	@echo "to do with packing reports and codes"

.PHONY: create submit


