all: up

# Create .env if doesn't exists & load it
$(shell test -f .env || cp .env.example .env)
include .env

SH=docker-compose exec app bash

.PHONY: up
up:
	docker-compose up -d --build
	@test -d vendor || ${SH} -c "composer install"
	@test -z ${APP_KEY} && ${SH} -c "php artisan key:generate" || exit 0

.PHONY: restart
restart:
	docker-compose restart

.PHONY: down
down:
	docker-compose down

.PHONY: sh
sh: up
	${SH}
