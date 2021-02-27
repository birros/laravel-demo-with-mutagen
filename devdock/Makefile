all: vscode

# Create .env if doesn't exists
$(shell test -f .env || cp .env.example .env)

# Populate UID & GID vars
$(shell sed -i '' 's/UID=.*/UID=$(shell id -u)/g' .env)
$(shell sed -i '' 's/GID=.*/GID=$(shell id -g)/g' .env)

# Load dot env
include .env

# Constants
GITCONFIG_PATH=${HOME}/$(shell readlink ${HOME}/.gitconfig || echo .gitconfig)

# Commands
SH_ROOT=docker-compose exec -u 0:0   app bash
SH_WWW= docker-compose exec -u 33:33 app bash
IF_EMPTY_APP_KEY=source .env; test -z \$${APP_KEY}
IF_NO_DOT_ENV=! test -f .env
COPY_GITCONFIG=docker cp ${GITCONFIG_PATH} $$(docker-compose ps -q app):/var/www/.gitconfig
ASK_CONFIRM=printf "Are you sure? [y/N] " && read ans && [ $${ans:-N} == y ]
PWD_HEX=$(shell printf $$PWD | xxd -pu | tr -d "\n\r")
WORKSPACE_FOLDER=$(shell grep workspaceFolder .devcontainer.json | sed 's/^ *"workspaceFolder" *: *"\(.*\)".*/\1/')
DOCKER_VOLUME_RM=VOLUMES=$$(docker run --rm -v $$PWD/docker-compose.yml:/docker-compose.yml:ro mikefarah/yq e '.volumes | keys | join(" ")' /docker-compose.yml) \
	&& for v in $$VOLUMES; do docker volume rm ${COMPOSE_PROJECT_NAME}_$$v; done

.PHONY: vscode
vscode:
	@code --folder-uri "vscode-remote://dev-container+${PWD_HEX}${WORKSPACE_FOLDER}"

.PHONY: docker-build
docker-build:
	docker-compose build

.PHONY: docker-up
docker-up: docker-build
	docker-compose up -d
	@${SH_ROOT} -c "chown -R www-data:www-data /var/www/.composer"
	@${SH_ROOT} -c "chown -R www-data:www-data /var/www/.npm"
	@${COPY_GITCONFIG}

.PHONY: up
up: docker-up
	@${SH_WWW} -c "${IF_NO_DOT_ENV}    && sed -e 's/DB_HOST=.*/DB_HOST=db/g' .env.example > .env" || exit 0
	@${SH_WWW} -c "${IF_EMPTY_APP_KEY} && composer install"                                       || exit 0
	@${SH_WWW} -c "${IF_EMPTY_APP_KEY} && npm install && npm run dev"                             || exit 0
	@${SH_WWW} -c "${IF_EMPTY_APP_KEY} && php artisan key:generate"                               || exit 0

.PHONY: restart
restart:
	docker-compose restart

.PHONY: docker-stop
docker-stop:
	docker-compose stop

.PHONY: stop
stop: docker-stop

.PHONY: docker-down
docker-down:
	docker-compose down

.PHONY: docker-volume-rm
docker-volume-rm:
	@${ASK_CONFIRM} && ${DOCKER_VOLUME_RM}

.PHONY: down
down: docker-down

.PHONY: sh
sh: up
	@${SH_WWW}

.PHONY: sh-root
sh-root: up
	@${SH_ROOT}
