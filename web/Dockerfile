# 
# Web Instance Container for Magento2 Base Image
#

FROM ubuntu:20.04
MAINTAINER hkdb <hkdb@3df.io>

#Set ENV to Non-Interactive Install
ENV DEBIAN_FRONTEND noninteractive

# Set WorkDIr
WORKDIR /home/magento

# Maker sure Ubuntu is up-to-date
RUN apt-get update -y
RUN apt-get dist-upgrade -y
RUN apt-get install -y software-properties-common dirmngr apt-transport-https lsb-release ca-certificates
RUN apt-get update -y
RUN apt-get upgrade -y

# Install all required PHP 7.4 packages
RUN apt-get install -y \
        php7.4 \
        php7.4-common \
        php7.4-cli \
        php7.4-fpm \
        php7.4-opcache \
        php7.4-gd \
        php7.4-mysql \
        php7.4-curl \
        php7.4-intl \
        php7.4-xsl \
        php7.4-mbstring \
        php7.4-zip \
        php7.4-bz2 \
        php7.4-bcmath \
        php7.4-soap

# Install all required tools packages
RUN apt-get install -y \
        rsyslog \
        gawk \
        vim \
        mysql-client \
        git \
        curl \
        unzip \
        cron

# Install all required server packages
RUN apt-get install -y \
        openssl \
        stunnel4 \
        nginx nginx-extras \
        certbot

# PHP Config
RUN sed -i "s/memory_limit = .*/memory_limit = 2048M/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/max_input_time = .*/max_input_time = 18000/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/upload_max_filesize = .*/upload_max_filesize = 256M/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/zlib.output_compression = .*/zlib.output_compression = on/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/max_execution_time = .*/max_execution_time = 18000/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/;date.timezone.*/date.timezone = UTC+8/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/;opcache.enable=*/opcache.enable=1/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/;opcache.enable_cli=*/opcache.enable_cli=1/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/;opcache.memory_consumption=128*/opcache.memory_consumption=512/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/;opcache.validate_timestamps=1*/opcache.validate_timestamps=0/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/;opcache.consistency_checks=0*/opcache.consistency_checks=0/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/;opcache.max_accelerated_files=100000*/opcache.max_accelerated_files=100000/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/;opcache.save_comments.*/opcache.save_comments = 1/" /etc/php/7.4/fpm/php.ini

# Add Magento code base
COPY magento-ce-2.4.2-p1-2021-04-22-10-49-09.zip /home/magento/
RUN cd /home/magento && unzip magento-ce-2.4.2-p1-2021-04-22-10-49-09.zip
RUN rm /home/magento/magento-ce-2.4.2-p1-2021-04-22-10-49-09.zip

# Create Magento User
RUN useradd -m -U -r -d /home/magento magento
RUN usermod -a -G magento www-data
RUN usermod --shell /bin/bash magento
RUN chmod 750 /home/magento

# Add custom conf for php-fpm
ADD magento.conf /etc/php/7.4/fpm/pool.d/magento.conf

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Magento Permissions
RUN cd /home/magento && find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
RUN cd /home/magento && find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
RUN cd /home/magento && chown -R magento:www-data .
RUN cd /home/magento && chmod u+x bin/magento

# Environment Variables
ENV APP_DOMAIN="3df.io"
ENV REMOTE_MASTER=""
ENV REMOTE_REPLICA=""
ENV APP_REDIS_MASTER_LOCAL_PORT="8000"
ENV APP_REDIS_REPLICA_LOCAL_PORT="8001"

# Add nginx config
ADD magento /etc/nginx/sites-available/
RUN cd /etc/nginx/sites-enabled && ln -s /etc/nginx/sites-available/magento .

# Install Elasticsearch
RUN apt-get install -y wget
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
RUN apt-get update -y && apt-get install -y elasticsearch
ADD elasticsearch /etc/default/

# Add interactive installation scirpt
ADD install.sh /home/magento
RUN chown magento:magento /home/magento/install.sh

# Redis
ADD redis.conf /etc/stunnel/
RUN mkdir -p /var/run/redis
RUN chown nobody:nogroup /var/run/redis

# Add entry point
ADD entry-point.sh /

# Expose Ports
EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entry-point.sh"]
