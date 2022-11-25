ID ?= 211240088
CREDIR = labs/$(NAME)
CREDIROJ = oj/$(NAME)

create:
	@mkdir $(CREDIR)
	@cat templates/template.mk >$(CREDIR)/makefile
	@cat templates/template.sv >$(CREDIR)/$(NAME).sv
	@cat templates/template_tb.sv >$(CREDIR)/$(NAME)_tb.sv
	@mkdir $(CREDIR)/include
	@cp -r libs/config $(CREDIR)/include/
	@cp .gitignore $(CREDIR)/
	@cp .svlint.toml $(CREDIR)/
	@sed -i 's/template/$(NAME)/g' $(CREDIR)/$(NAME).sv $(CREDIR)/$(NAME)_tb.sv

create-oj:
	@mkdir $(CREDIROJ)
	@cat templates/template_oj.mk >$(CREDIROJ)/makefile
	@cat templates/template.sv >$(CREDIROJ)/$(NAME).sv
	@cat templates/template_tb.sv >$(CREDIROJ)/$(NAME)_tb.sv
	@cp .gitignore $(CREDIROJ)/
	@cp .svlint.toml $(CREDIROJ)/
	@sed -i 's/template/$(NAME)/g' $(CREDIROJ)/$(NAME).sv $(CREDIROJ)/$(NAME)_tb.sv
	@sed -i '1,4d' $(CREDIROJ)/$(NAME).sv

submit:
	@echo "to do with packing reports and codes"

.PHONY: create submit


