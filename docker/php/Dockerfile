FROM php:8.2-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    oniguruma-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    bash \
    mysql-client \
    nodejs \
    npm

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install \
        pdo_mysql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        opcache

# Install Redis extension
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create www-data user with specific UID/GID
RUN addgroup -g 1000 -S www && \
    adduser -u 1000 -S www -G www

# Copy PHP configuration
COPY docker/php/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY docker/php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Copy initialization script
COPY docker/php/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Set working directory
WORKDIR /var/www/html

# Expose port 9000 for PHP-FPM
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/init.sh"]
