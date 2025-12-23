#!/bin/bash

# Print commands and exit on error
set -xe

# Install required dependencies
apt-get update -yqq
apt-get install -yqq \
    acl \
    build-essential \
    git \
    jpegoptim \
    libz-dev \
    optipng \
    pngquant \
    software-properties-common \
    unzip \
    zip \
    libgmp-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libicu-dev \
    libedit-dev \
    libreadline-dev \
    libxml2-dev \
    zlib1g-dev \
    libjpeg-dev \
    libonig-dev \
    libwebp-dev \
    webp

# Configure extensions
docker-php-ext-configure gmp
docker-php-ext-configure intl
docker-php-ext-configure zip
docker-php-ext-configure gd --with-jpeg --with-webp

# Install extensions
docker-php-ext-install -j "$(nproc)" \
    bcmath \
    exif \
    gd \
    gmp \
    intl \
    mysqli \
    pcntl \
    pdo_mysql \
    zip

docker-php-ext-install sockets

# Install redis
yes 'no' | pecl install redis
docker-php-ext-enable redis
