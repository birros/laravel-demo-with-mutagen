all: up

# Create .env if doesn't exists & load it
$(shell test -f .env || cp .env.example .env)
include .env

# Constants
GITCONFIG_PATH=${HOME}/$(shell readlink ${HOME}/.gitconfig || echo .gitconfig)

# Commands
SH_ROOT=docker-compose exec -u 0:0   app bash
SH_WWW= docker-compose exec -u 33:33 app bash
IF_EMPTY_APP_KEY=source .env; test -z \$${APP_KEY}
IF_NO_DOT_ENV=! test -f .env
COPY_GITCONFIG=docker cp ${GITCONFIG_PATH} $$(docker-compose ps -q app):/var/www/.gitconfig
GENERATE_MUTAGEN=set -a; source $$PWD/.env; envsubst < mutagen.template.yml > mutagen.yml

.PHONY: docker-build
docker-build:
	docker-compose build

.PHONY: docker-up
docker-up: docker-build
	docker-compose up -d
	@${COPY_GITCONFIG}

.PHONY: mutagen-up
mutagen-up: docker-up
	@${GENERATE_MUTAGEN}
	mutagen project start || exit 0

.PHONY: up
up: mutagen-up
	@${SH_WWW} -c "${IF_NO_DOT_ENV}    && sed -e 's/DB_HOST=.*/DB_HOST=db/g' .env.example > .env" || exit 0
	@${SH_WWW} -c "${IF_EMPTY_APP_KEY} && source /etc/bash.bashrc && composer install"            || exit 0
	@${SH_WWW} -c "${IF_EMPTY_APP_KEY} && npm install && npm run dev"                             || exit 0
	@${SH_WWW} -c "${IF_EMPTY_APP_KEY} && php artisan key:generate"                               || exit 0

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
