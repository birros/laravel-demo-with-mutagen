all: up

# Create .env if doesn't exists & load it
$(shell test -f .env || cp .env.example .env)
include .env

SH_ROOT=docker-compose exec -u 0:0   app bash
SH_WWW= docker-compose exec -u 33:33 app bash
GITCONFIG_PATH=${HOME}/$(shell readlink ${HOME}/.gitconfig || echo ${HOME}/.gitconfig)

.PHONY: docker-build
docker-build:
	docker-compose build

.PHONY: docker-up
docker-up: docker-build
	docker-compose up -d
	@docker cp ${GITCONFIG_PATH} $$(docker-compose ps -q app):/var/www/.gitconfig

.PHONY: mutagen-up
mutagen-up: docker-up
	@sed -e "s/\$${PROJECT_NAME}/${PROJECT_NAME}/g" mutagen.template.yml > mutagen.yml
	mutagen project start || exit 0

.PHONY: up
up: mutagen-up
	@test -z ${APP_KEY} && ${SH_WWW} -c "source /etc/bash.bashrc && composer install" || exit 0
	@test -z ${APP_KEY} && ${SH_WWW} -c "npm install && npm run dev"                  || exit 0
	@test -z ${APP_KEY} && ${SH_WWW} -c "php artisan key:generate"                    || exit 0

.PHONY: restart
restart:
	docker-compose restart

.PHONY: mutagen-down
mutagen-down:
	mutagen project terminate || exit 0

.PHONY: docker-stop
docker-stop: mutagen-down
	docker-compose stop

.PHONY: stop
stop: docker-stop

.PHONY: docker-down
docker-down: mutagen-down
	docker-compose down

.PHONY: down
down: docker-down

.PHONY: sh
sh: up
	@${SH_WWW}

.PHONY: sh-root
sh-root: up
	@${SH_ROOT}
