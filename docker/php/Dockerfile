FROM php:8.4-fpm

# Install dependencies dan PHP extensions
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    zlib1g-dev \
    && docker-php-ext-install pdo_pgsql mbstring bcmath opcache zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy custom php.ini
COPY php.ini /usr/local/etc/php/

EXPOSE 9000
