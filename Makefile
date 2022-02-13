all: check

check:
	@$(shell) ./scripts/check.sh

.PHONY: uninstall
uninstall:
	@$(shell) ./scripts/uninstall.sh

install:
	@$(shell) ./scripts/install.sh

update:
	@$(shell) ./scripts/update.sh
