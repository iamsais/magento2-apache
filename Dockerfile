FROM ubuntu:16.10

MAINTAINER sathish26586@gmail.com

RUN apt-get update && \
    apt-get install -y \
        apache2 \
        wget \
        nano \
        composer \
        php \
        libapache2-mod-php \
        php-mcrypt \
        php-curl \
        php-cli \
        php-mysql \
        php-gd \
        php-xsl \
        php-json \
        php-intl \
        php-pear \
        php-dev \
        php-common \
        php-mbstring \
        php-zip \
        php-soap \
        libcurl3 \
        curl \
        php-bcmath

RUN apt-get install -y librdkafka-dev
RUN pecl install rdkafka

#RUN useradd -m -d /var/www/html/ webdata -s /bin/bash && usermod -a -G www-data webdata

# clear apt cache and remove unnecessary packages
RUN apt-get autoclean && apt-get -y autoremove

COPY rdkafka.ini /etc/php/7.0/mods-available/
COPY 20-rdkafka.ini /etc/php/7.0/apache2/conf.d/

# Move Apache2 conf file
COPY apache2.conf /etc/apache2/

# Copy php.ini to php cli
COPY php.ini /etc/php/7.0/apache2/

# To enable htaccess rewrite rules
RUN a2enmod rewrite && \
    a2enmod headers

EXPOSE 80 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
