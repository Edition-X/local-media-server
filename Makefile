PYTHON_VIRTUAL_ENVIRONMENT := venv
PYTHON_REQUIREMENTS_FILE   := requirements.txt
ANSIBLE_PLAYBOOK_FILE      := site.yml

.DEFAULT_GOAL := $(PYTHON_VIRTUAL_ENVIRONMENT)

define activate
	(. $(PYTHON_VIRTUAL_ENVIRONMENT)/bin/activate && unset ANSIBLE_VAULT_PASSWORD_FILE && $1;)
endef

$(PYTHON_VIRTUAL_ENVIRONMENT): $(PYTHON_REQUIREMENTS_FILE)
	@python3 -m venv $(PYTHON_VIRTUAL_ENVIRONMENT)
	@$(call activate, pip install --upgrade pip)
	@$(call activate, pip install wheel)
	@$(call activate, pip install -r $(PYTHON_REQUIREMENTS_FILE))

.PHONY: up
up: $(PYTHON_VIRTUAL_ENVIRONMENT)
	@$(call activate, ANSIBLE_COW_SELECTION=tux ansible-playbook $(ANSIBLE_PLAYBOOK_FILE) $(RUN_ARGS) --tags core)

.PHONY: down
down: $(PYTHON_VIRTUAL_ENVIRONMENT)
	@$(call activate, ANSIBLE_COW_SELECTION=tux ansible-playbook $(ANSIBLE_PLAYBOOK_FILE) $(RUN_ARGS) --tags down)
