SHELL = /bin/sh

.PHONY: install composer clean help
.PHONY: test test-unit test-coverage

.SILENT: help

install: ## Download the depenedencies then build the image :rocket:.
	docker pull php:5.6-cli
	docker pull php:7.0-cli
	docker run -it --rm \
		-v $$(pwd):/usr/src/app \
		-v ~/.composer:/root/.composer \
		-v ~/.ssh:/root/.ssh:ro \
		graze/composer update --no-interaction

test: ## Run the unit and intergration testsuites.
test: test-unit

test-unit: ## Run the unit testsuite.
	docker run --rm -t -v $$(pwd):/opt/graze/queue -w /opt/graze/queue php:5.6-cli \
	vendor/bin/phpunit --testsuite unit
	docker run --rm -t -v $$(pwd):/opt/graze/queue -w /opt/graze/queue php:7.0-cli \
	vendor/bin/phpunit --testsuite unit

test-coverage: ## Run the testsuites with coverage enabled.
	docker run --rm -t -v $$(pwd):/opt/graze/queue -w /opt/graze/queue php:5.6-cli \
	vendor/bin/phpunit --coverage-text --testsuite unit

clean: ## Stop running containers and clean up an images.
	rm -rf vendor/

help: ## Show this help message.
	echo "usage: make [target] ..."
	echo ""
	echo "targets:"
	fgrep --no-filename "##" $(MAKEFILE_LIST) | fgrep --invert-match $$'\t' | sed -e 's/## / - /'
