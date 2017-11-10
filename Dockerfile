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

RUN git clone https://github.com/edenhill/librdkafka.git && \
	cd librdkafka && \
	./configure && make && make install && \
	ls -l /usr/local/lib/ && \
	pecl install rdkafka

# clear apt cache and remove unnecessary packages
RUN apt-get autoclean && apt-get -y autoremove

COPY rdkafka.ini /etc/php/7.0/mods-available/

# Move Apache2 conf file
COPY apache2.conf /etc/apache2/

# To enable htaccess rewrite rules
RUN a2enmod_rewrite

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
