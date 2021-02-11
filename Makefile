all: up

# Create .env if doesn't exists & load it
$(shell test -f .env || cp .env.example .env)
include .env

DOCKER_COMPOSE=mutagen compose

SH_ROOT=${DOCKER_COMPOSE} exec -u 0:0   app bash
SH_WWW= ${DOCKER_COMPOSE} exec -u 33:33 app bash

.PHONY: up
up:
	@${DOCKER_COMPOSE} up -d --build
	@${SH_ROOT} -c "chown www-data:www-data /var/www/html"
	@test -z ${APP_KEY} && ${SH_WWW} -c "source /etc/bash.bashrc && composer install" || exit 0
	@test -z ${APP_KEY} && ${SH_WWW} -c "npm install"                                 || exit 0
	@test -z ${APP_KEY} && ${SH_WWW} -c "php artisan key:generate"                    || exit 0

.PHONY: restart
restart:
	@${DOCKER_COMPOSE} restart

.PHONY: down
down:
	@${DOCKER_COMPOSE} down

.PHONY: sh
sh: up
	@${SH_WWW}

.PHONY: sh-root
sh-root: up
	@${SH_ROOT}
