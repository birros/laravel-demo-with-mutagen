ARG PHP_VERSION=latest
ARG COMPOSER_VERSION=latest

# ARG connot be used in COPY
FROM composer:${COMPOSER_VERSION} as composer

FROM php:${PHP_VERSION}-fpm

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y \
        zip \
        libzip-dev \
        git \
        bsdtar \
    && apt-get clean -y \
    && docker-php-ext-configure \
        zip \
    && docker-php-ext-install -j$(nproc) \
        zip \
        mysqli \
        pdo \
        pdo_mysql

# disable npm update check
ENV NO_UPDATE_NOTIFIER true

# "node" is an alias for the latest version of node with nvm
ARG NODE_VERSION=node
ENV NODE_VERSION ${NODE_VERSION}

# install node
ENV NVM_DIR /opt/nvm
RUN mkdir -p ${NVM_DIR} \
    && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.37.2/install.sh | bash \
    && . ${NVM_DIR}/nvm.sh \
    && nvm install ${NODE_VERSION} \
    && nvm use ${NODE_VERSION} \
    && nvm alias ${NODE_VERSION} \
    && ln -s ${NVM_DIR}/versions/node/* ${NVM_DIR}/versions/node/current

# add node to path
ENV PATH ${NVM_DIR}/versions/node/current/bin:$PATH

# preinstall vscode-server
ENV VSCODE_SERVER_COMMIT=622cb03f7e070a9670c94bae1a45d78d7181fbd4
RUN mkdir -p /var/www/.vscode-server \
    && touch /var/www/.gitconfig \
    && mkdir /var/www/.ssh \
    && mkdir -p /var/www/.vscode-server/bin/${VSCODE_SERVER_COMMIT} \
    && curl -sSL "https://update.code.visualstudio.com/commit:${VSCODE_SERVER_COMMIT}/server-linux-x64/stable" \
        | tar zxvf - -C /var/www/.vscode-server/bin/${VSCODE_SERVER_COMMIT} --strip 1

# preinstall vscode extensions
ENV INTELEPHENSE_VERSION=1.6.3 \
    PRETTIER_VERSION=5.9.2 \
    DOCKER_VERSION=1.9.1
RUN mkdir -p /var/www/.vscode-server/extensions \
    && cd /var/www/.vscode-server/extensions \
        # intelephense
        && curl -sSL https://github.com/bmewburn/vscode-intelephense/releases/download/v${INTELEPHENSE_VERSION}/vscode-intelephense-client-${INTELEPHENSE_VERSION}.vsix \
            | bsdtar -xvf - extension \
        && mv /var/www/.vscode-server/extensions/extension \
            /var/www/.vscode-server/extensions/bmewburn.vscode-intelephense-client-${INTELEPHENSE_VERSION} \
        # prettier
        && curl -sSL https://github.com/prettier/prettier-vscode/releases/download/v${PRETTIER_VERSION}/prettier-vscode-${PRETTIER_VERSION}.vsix \
            | bsdtar -xvf - extension \
        && mv /var/www/.vscode-server/extensions/extension \
            /var/www/.vscode-server/extensions/esbenp.prettier-vscode-${PRETTIER_VERSION} \
        # docker
        && curl -sSL https://github.com/microsoft/vscode-docker/releases/download/v${DOCKER_VERSION}/vscode-docker-${DOCKER_VERSION}.vsix \
            | bsdtar -xvf - extension \
        && mv /var/www/.vscode-server/extensions/extension \
            /var/www/.vscode-server/extensions/ms-azuretools.vscode-docker-${DOCKER_VERSION}

# change /var/www ownership
RUN chown -R www-data:www-data /var/www
