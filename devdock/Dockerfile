ARG PHP_VERSION=latest
ARG COMPOSER_VERSION=latest

# ARG connot be used in COPY
FROM composer:${COMPOSER_VERSION} as composer

FROM php:${PHP_VERSION}-apache

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y \
        zip \
        libzip-dev \
        nodejs \
        git \
        bsdtar \
    && apt-get clean -y \
    && docker-php-ext-configure \
        zip \
    && docker-php-ext-install -j$(nproc) \
        zip \
        mysqli \
        pdo \
        pdo_mysql \
    && a2enmod rewrite

# disable npm update check & change npm & composer folders
ENV NO_UPDATE_NOTIFIER true
RUN npm config set cache /var/www/html/.npm --global \
    && echo "export COMPOSER_HOME=/var/www/html/.composer" \
        | cat - /etc/bash.bashrc | cat - > /etc/bash.bashrc

# change APACHE_DOCUMENT_ROOT
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
        /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' \
        /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

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
    PHPFMT_VERSION=1.0.30 \
    PRETTIER_VERSION=5.9.2 \
    DOCKER_VERSION=1.9.1
RUN mkdir -p /var/www/.vscode-server/extensions \
    && cd /var/www/.vscode-server/extensions \
        # intelephense
        && curl -sSL https://marketplace.visualstudio.com/_apis/public/gallery/publishers/bmewburn/vsextensions/vscode-intelephense-client/${INTELEPHENSE_VERSION}/vspackage \
            | bsdtar -xvf - extension \
        && mv /var/www/.vscode-server/extensions/extension \
            /var/www/.vscode-server/extensions/bmewburn.vscode-intelephense-client-${INTELEPHENSE_VERSION} \
        # phpfmt
        && curl -sSL https://marketplace.visualstudio.com/_apis/public/gallery/publishers/kokororin/vsextensions/vscode-phpfmt/${PHPFMT_VERSION}/vspackage \
            | bsdtar -xvf - extension \
        && mv /var/www/.vscode-server/extensions/extension \
            /var/www/.vscode-server/extensions/kokororin.vscode-phpfmt-${PHPFMT_VERSION} \
        # prettier
        && curl -sSL https://marketplace.visualstudio.com/_apis/public/gallery/publishers/esbenp/vsextensions/prettier-vscode/${PRETTIER_VERSION}/vspackage \
            | bsdtar -xvf - extension \
        && mv /var/www/.vscode-server/extensions/extension \
            /var/www/.vscode-server/extensions/esbenp.prettier-vscode-${PRETTIER_VERSION} \
        # docker
        && curl -sSL https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-azuretools/vsextensions/vscode-docker/${DOCKER_VERSION}/vspackage \
            | bsdtar -xvf - extension \
        && mv /var/www/.vscode-server/extensions/extension \
            /var/www/.vscode-server/extensions/ms-azuretools.vscode-docker-${DOCKER_VERSION}

# change /var/www ownership
RUN chown -R www-data:www-data /var/www
