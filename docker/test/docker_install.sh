#!/bin/bash

# Print commands and exit on error
set -xe

# Install dependencies
apk add --no-cache \
    git \
    freetype-dev \
    gmp-dev \
    icu-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp \
    libwebp-dev \
    libwebp-tools \
    libzip-dev \
    jpeg-dev \
    unzip \
    zip \
    linux-headers

# Configure extensions
docker-php-ext-configure gmp
docker-php-ext-configure intl
docker-php-ext-configure zip
docker-php-ext-configure gd --with-jpeg --with-webp

# Install PHP extensions
docker-php-ext-install -j "$(nproc)" \
    bcmath \
    exif \
    gd \
    gmp \
    intl \
    mysqli \
    pcntl \
    pdo_mysql \
    zip \
    sockets

# Install sockets extension
apk add --no-cache --virtual .build-deps $PHPIZE_DEPS
docker-php-ext-install sockets
pecl install xdebug-3.4.2
docker-php-ext-enable xdebug
apk del -f .build-deps
