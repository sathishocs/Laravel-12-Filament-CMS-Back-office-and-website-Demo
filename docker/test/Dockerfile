FROM composer/composer:2.6-bin AS composer

FROM php:8.3-cli-alpine

COPY --from=composer /composer /usr/bin/composer

COPY ./docker_install.sh /docker/
RUN sh /docker/docker_install.sh > /dev/null

RUN echo 'memory_limit = -1' >> $PHP_INI_DIR/conf.d/docker-memory_limit.ini
RUN echo 'opcache.enable_cli=1'  >> $PHP_INI_DIR/conf.d/docker-opcache.ini

WORKDIR /app
