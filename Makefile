.DEFAULT_GOAL=help
WWW_USER_ID=${shell id -u}
WORKSPACE_CONTAINER=$(shell docker compose ps -q workspace 2> /dev/null)
MYSQL_CONTAINER=$(shell docker compose ps -q mysql 2> /dev/null)
MKCERT:=$(shell command -v mkcert 2> /dev/null)

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.PHONY: help
help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: init
init: ## Install the project
	rsync --ignore-existing .env.example .env
	@make -s build
	@ON_INIT=1 make -s generate-ssl-certs
	@make -s start
	@make -s composer
	@make -s npm-upgrade
	@make -s npm-install
	@make -s npm-build
	@docker compose exec --user app workspace /bin/bash -c "php artisan key:generate"
	@docker compose exec --user app workspace /bin/bash -c "php artisan migrate:fresh --seed"
	@docker compose exec --user app workspace /bin/bash -c "php artisan storage:link"
	@make -s install-git-hooks
	@docker compose exec --user app workspace /bin/bash -c "php artisan passport:client --password --name='Bois de France Password Grant Client' --provider=users"

.PHONY: install-git-hooks
install-git-hooks: ## Install git hooks
	@git config core.hooksPath .captainhooks

.PHONY: disable-git-hooks
disable-git-hooks: ## Disable git hooks from the project
	@git config --unset core.hooksPath

.PHONY: build
build: ## Rebuild the containers
	@docker compose --profile test build --parallel

.PHONY: start
start: ## Start the docker containers
	@WWW_USER_ID=${WWW_USER_ID} docker compose up --pull missing --remove-orphans -d

.PHONY: stop
stop: ## Stop the docker server
	@docker compose stop

.PHONY: logs
logs: ## Show logs
	@docker compose logs --tail=0 --follow

.PHONY: restart
restart: ## Restart the docker server
	@docker compose restart
	@make -s restart-webserver

.PHONY: restart-webserver
restart-webserver: ## Restart the webserver (caddy)
	@docker compose exec web /bin/sh -c "cd /etc/caddy && caddy reload 2> /dev/null"

.PHONY: down
down: ## Stop the docker server and remove containers
	@docker compose down

.PHONY: destroy
destroy: ## Remove containers, local images and volumes
	@docker compose down --rmi local --volumes

.PHONY: generate-ssl-certs
generate-ssl-certs: ## Generate SSL certificates
ifdef MKCERT
	@mkcert -cert-file docker/caddy/certs/cert.pem -key-file docker/caddy/certs/key.pem ${SERVER_NAME}
else
	@openssl req -x509 -newkey rsa:2048 -nodes -keyout docker/caddy/certs/key.pem -out docker/caddy/certs/cert.pem -sha256 -days 365 -subj "/CN=localhost" > /dev/null
endif
ifndef ON_INIT
	@make -s restart-webserver
endif

.PHONY: npm-install
npm-install: ## Run npm install
	@docker exec -it --user app ${WORKSPACE_CONTAINER} /bin/bash -c "npm ci"

.PHONY: npm-upgrade
npm-upgrade: ## Upgrade npm to its latest version
	@docker exec -it --user root ${WORKSPACE_CONTAINER} /bin/bash -c "npm install npm@latest -g"

.PHONY: npm-dev
npm-dev: ## Run npm dev
	@docker exec -it --user app ${WORKSPACE_CONTAINER} /bin/bash -c "npm run dev"

.PHONY: npm-build
npm-build: ## Run npm build
	@docker exec -it --user app ${WORKSPACE_CONTAINER} /bin/bash -c "npm run build"

.PHONY: npm-lint
npm-lint: ## Run npm lint
	@docker exec -it --user app ${WORKSPACE_CONTAINER} /bin/bash -c "npm run lint"

.PHONY: npm-sass-fix
npm-sass-fix: ## Run npm sass:fix
	@docker exec -it --user app ${WORKSPACE_CONTAINER} /bin/bash -c "npm run sass:fix"

.PHONY: tinker
tinker: ## Run laravel tinker
	@docker exec -it --user app ${WORKSPACE_CONTAINER} /bin/bash -c "php artisan tinker"

.PHONY: migrate
migrate: ## Run laravel migrations
	@docker exec -it --user app ${WORKSPACE_CONTAINER} /bin/bash -c "php artisan migrate"

.PHONY: workspace
workspace: ## Connect to the workspace container
	@docker exec -it --user app ${WORKSPACE_CONTAINER} /bin/bash

.PHONY: cmd
cmd: ## Run a custom command in workspace by passing "c=" parameter
	@$(eval c ?=)
	@docker exec -t --user app ${WORKSPACE_CONTAINER} /bin/bash -c "$(c)"

.PHONY: composer
composer: ## Install composer dependencies
	@docker exec -t --user app ${WORKSPACE_CONTAINER} /bin/bash -c "composer install"

.PHONY: lint
lint: ## Run linter
	@docker compose run --rm composer /bin/sh -c "composer lint"

.PHONY: fix
fix: ## Run php-cs-fixer
	@docker exec -t --user app ${WORKSPACE_CONTAINER} /bin/bash -c "vendor/bin/pint"

.PHONY: rector
rector: ## Run rector in dry-run mode
	@docker compose run --user ${WWW_USER_ID} --rm composer /bin/sh -c "composer rector"

.PHONY: run-rector
run-rector: ## Run rector process
	@docker exec -t --user app ${WORKSPACE_CONTAINER} /bin/bash -c "vendor/bin/rector process --config rector.php"

.PHONY: phpstan
phpstan: ## Run phpstan
	@docker compose run --user ${WWW_USER_ID} --rm composer /bin/sh -c "composer phpstan"

.PHONY: insights
insights: ## Run insights
	@docker compose run --user ${WWW_USER_ID} --rm composer /bin/sh -c "composer insights"

.PHONY: test
test: ## Run test suit
	@docker compose exec --user app workspace /bin/bash -c "php artisan view:clear"
	@docker compose run --user ${WWW_USER_ID} --rm workspace /bin/sh -c "composer test"

.PHONY: mysql
mysql: ## Execute the MySQL CLI
	@docker exec -it ${MYSQL_CONTAINER} /bin/bash -c 'mysql -u $$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE'