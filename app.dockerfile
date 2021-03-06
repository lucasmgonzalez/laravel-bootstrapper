FROM php:fpm

RUN apt-get update \
    && apt-get install -y \
        libhiredis-dev \
        cron \
        # libpq-dev \
        # libfreetype6-dev \
        # libjpeg62-turbo-dev \
        # libpng12-dev \
        # libbz2-dev \
    && pecl channel-update pecl.php.net \
    && pecl install redis apcu \
    && docker-php-ext-install \
        pdo_mysql \
        mbstring \
        # zip \
        # bz2 \
        # pcntl \
    && docker-php-ext-enable redis
    # && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    # && docker-php-ext-install gd

# # Memory Limit
# RUN echo "memory_limit=2048M" > $PHP_INI_DIR/conf.d/memory-limit.ini
# RUN echo "max_execution_time=900" >> $PHP_INI_DIR/conf.d/memory-limit.ini
# RUN echo "extension=apcu.so" > $PHP_INI_DIR/conf.d/apcu.ini
# RUN echo "post_max_size=20M" >> $PHP_INI_DIR/conf.d/memory-limit.ini
# RUN echo "upload_max_filesize=20M" >> $PHP_INI_DIR/conf.d/memory-limit.ini

# # Time Zone
# RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini

# # Display errors in stderr
# RUN echo "display_errors=stderr" > $PHP_INI_DIR/conf.d/display-errors.ini

# # Disable PathInfo
# RUN echo "cgi.fix_pathinfo=0" > $PHP_INI_DIR/conf.d/path-info.ini

# # Disable expose PHP
# RUN echo "expose_php=0" > $PHP_INI_DIR/conf.d/path-info.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD . /var/www/html
WORKDIR /var/www/html

RUN touch storage/logs/laravel.log

RUN composer install
RUN php artisan cache:clear && \
    php artisan view:clear && \
    php artisan route:cache

RUN chmod -R 777 /var/www/html/storage

# ADD deploy/cron/artisan-schedule-run /etc/cron.d/artisan-schedule-run
# RUN chmod 0644 /etc/cron.d/artisan-schedule-run
# RUN chmod +x /etc/cron.d/artisan-schedule-run
RUN touch /var/log/cron.log

CMD ["/bin/sh", "-c", "php-fpm -D | tail -f storage/logs/laravel.log"]


# RUN apt-get update && apt-get install -y libmcrypt-dev \
#     mysql-client libmagickwand-dev --no-install-recommends \
#     && pecl install imagick \
#     && docker-php-ext-enable imagick \
#     && docker-php-ext-install mcrypt pdo_mysql
