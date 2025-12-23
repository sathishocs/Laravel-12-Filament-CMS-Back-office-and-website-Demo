FROM php:8.3-fpm

# Install PHP extensions with mlocati installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions \
        pdo_mysql \
        gd \
        intl \
        zip \
        bcmath \
        opcache

# Define default env variables
ARG WWW_USER_ID
ENV WWW_UID=${WWW_USER_ID:-1000}

# PHP-fpm configuration
COPY --link ./php-fpm/config/pool.conf /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/user = www-data/user = $WWW_UID/g" /usr/local/etc/php-fpm.d/www.conf

# Copy Xdebug configuration
COPY --link ./shared/config/xdebug.ini $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini

EXPOSE 9000
WORKDIR /var/www/html
RUN chown ${WWW_USER}:www-data /var/www/html
