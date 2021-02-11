ARG PHP_VERSION=8.0.2
ARG COMPOSER_VERSION=2.0.9

# ARG connot be used in COPY
FROM composer:${COMPOSER_VERSION} as composer

FROM php:${PHP_VERSION}-apache

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y \
        zip \
        libzip-dev \
        nodejs \
    && apt-get clean -y \
    && docker-php-ext-configure \
        zip \
    && docker-php-ext-install -j$(nproc) \
        zip \
        mysqli \
        pdo \
        pdo_mysql

# change composer folder
RUN echo "export COMPOSER_HOME=/var/www/html/.composer" | cat - /etc/bash.bashrc | cat - > /etc/bash.bashrc
# change npm folder
RUN npm config set cache /var/www/html/.npm --global
# disable npm update check
ENV NO_UPDATE_NOTIFIER true

# change APACHE_DOCUMENT_ROOT
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN a2enmod rewrite
