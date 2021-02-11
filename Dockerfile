ARG PHP_VERSION=8.0.2
ARG COMPOSER_VERSION=2.0.9

FROM composer:${COMPOSER_VERSION} as composer

FROM php:${PHP_VERSION}-apache

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y \
        zip \
        libzip-dev \
    && apt-get clean -y \
    && docker-php-ext-configure zip \
    && docker-php-ext-install -j$(nproc) zip mysqli pdo pdo_mysql

ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
