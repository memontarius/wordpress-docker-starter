FROM php:8.4-fpm

# Install packages
RUN apt-get update && apt-get install -y \
      apt-utils \
      libavif-dev \
      libfreetype6-dev \
      libjpeg-dev \
      libmagickwand-dev \
      libwebp-dev \
      libpq-dev \
      libpng-dev \
      libicu-dev \
      libzip-dev \
      zip unzip \
      libxml2-dev \
      libonig-dev\
      git && \
      docker-php-ext-install mysqli && \
      docker-php-ext-install bcmath && \
      docker-php-ext-install exif && \
      docker-php-ext-install gd && \
      docker-php-ext-install zip && \
      docker-php-ext-configure intl &&  \
      docker-php-ext-install intl && \
      docker-php-ext-install xml && \
      docker-php-ext-install mbstring && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www

# Configure non-root user.
ARG PUID=1000
ARG PGID=1000
RUN groupmod -o -g ${PGID} www-data && \
    usermod -o -u ${PUID} -g www-data www-data

RUN chown -R www-data:www-data /var/www

COPY ./_docker/app/php.ini /usr/local/etc/php/conf.d/php.ini

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

CMD php-fpm
EXPOSE 9000
