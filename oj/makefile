create:
	@mkdir $(NAME)
	@cat ../templates/template_oj.mk >$(NAME)/makefile
	@cat ../templates/template.sv >$(NAME)/$(NAME).sv
	@cat ../templates/template_tb.sv >$(NAME)/$(NAME)_tb.sv
	@cp ../.gitignore $(NAME)/
	@cp ../.svlint.toml $(NAME)/
	@sed -i 's/template/$(NAME)/g' $(NAME)/$(NAME).sv $(NAME)/$(NAME)_tb.sv
	@sed -i '1,4d' $(NAME)/$(NAME).sv
.PHONY: create
