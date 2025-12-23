FROM composer/composer:2.6-bin AS composer

FROM php:8.3-cli-alpine

COPY --from=composer --link /composer /usr/bin/composer

RUN apk add --no-cache icu-dev zip unzip libzip-dev\
    && docker-php-ext-configure intl \
    && docker-php-ext-configure zip \
    && docker-php-ext-install -j "$(nproc)" intl zip

WORKDIR /app
