FROM php:8.1-apache

ARG ECCUBE_VERSION

RUN apt-get update
RUN apt-get install -y libonig-dev libzip-dev libicu-dev wget unzip
RUN a2enmod rewrite

# PHP
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install zip
RUN docker-php-ext-install intl
RUN docker-php-ext-install opcache && docker-php-ext-enable opcache
RUN pecl install apcu && docker-php-ext-enable apcu

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

RUN wget https://downloads.ec-cube.net/src/eccube-${ECCUBE_VERSION}.zip && unzip eccube-${ECCUBE_VERSION}.zip
RUN ls -la
RUN mv ec-cube/* ec-cube/.[^.]* /var/www/html
RUN rm -rf eccube-${ECCUBE_VERSION}.zip ec-cube

COPY ./config/php/php.ini /usr/local/etc/php/
