all: up

# Create .env if doesn't exists & load it
$(shell test -f .env || cp .env.example .env)
include .env

SH_ROOTdocker-compose exec -u 0:0   app bash
SH_WWW= docker-compose exec -u 33:33 app bash

.PHONY: docker-up
docker-up:
	docker-compose up -d --build
	@${SH_ROOT} -c "chown www-data:www-data /var/www/html"

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
