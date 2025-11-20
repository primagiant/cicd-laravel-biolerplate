FROM php:8.4-fpm

RUN apt-get update && apt-get install -y \
    libpq-dev \
    zip unzip git curl \
    && docker-php-ext-install pdo_pgsql mbstring bcmath opcache

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY php.ini /usr/local/etc/php/

EXPOSE 9000
