FROM composer/composer:2.6-bin AS composer

FROM node:22.11-bookworm AS node

FROM php:8.3-cli-bullseye

# Install php extensions
COPY --link ./shared/install_php_extensions.sh /docker/
RUN chmod +x /docker/install_php_extensions.sh
RUN /docker/install_php_extensions.sh

# Install MySQL client
RUN apt-get update -yqq && apt-get install -yqq mariadb-client

# Install composer
COPY --from=composer --link /composer /usr/local/bin/composer

# Copy node files
COPY --from=node --link /usr/local/include/node /usr/local/include/node
COPY --from=node --link /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node --link /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

# Install ffmpeg
RUN apt-get update -yqq && apt-get install -yqq ffmpeg

# Define memory_limit
RUN echo 'memory_limit = -1' >> $PHP_INI_DIR/conf.d/docker-memory_limit.ini

# Enable opcache
RUN echo 'opcache.enable_cli=1'  >> $PHP_INI_DIR/conf.d/docker-opcache.ini

# Set web directory as safe for git
RUN git config --system --add safe.directory /var/www/html

# Create the main user
ARG WWW_USER_ID
ENV WWW_UID=${WWW_USER_ID:-1000}
RUN useradd -ms /bin/bash -u ${WWW_UID} app

WORKDIR /var/www/html

USER app

EXPOSE 3000 3001
