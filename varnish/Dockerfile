# 
# Varnish Instance Container for Magento2
#

FROM ubuntu:20.04
MAINTAINER hkdb <hkdb@3df.io>

#Set ENV to Non-Interactive Install
ENV DEBIAN_FRONTEND noninteractive

# Set WorkDIr
WORKDIR /etc/varnish

# Maker sure Ubuntu is up-to-date
RUN apt-get update -y
RUN apt-get dist-upgrade -y
RUN apt-get install -y software-properties-common dirmngr apt-transport-https lsb-release ca-certificates
RUN apt-get update -y
RUN apt-get upgrade -y

# Install all required tools packages
RUN apt-get install -y \
        rsyslog \
        gawk \
        vim \
        git \
        curl \
        cron

# Install all required server packages
RUN apt-get install -y \
        openssl \
        stunnel4 \
        varnish \
        nginx nginx-extras 

# Add nginx config
ADD magento-standalone /etc/nginx/sites-available/
RUN mv /etc/nginx/sites-available/magento-standalone /etc/nginx/sites-available/magento
RUN cd /etc/nginx/sites-enabled && ln -s /etc/nginx/sites-available/magento .

# stunnel for Varnish
ADD magento.conf /etc/stunnel/
RUN mkdir -p /var/run/magento
RUN chown nobody:nogroup /var/run/magento

# Configure Varnish
ADD default.vcl /etc/varnish/
ADD multi-node.conf /etc/varnish/
ADD cluster.conf /etc/varnish/

# Enable Varnish
COPY varnish /etc/default/

# Add entry point
ADD entry-point.sh /

# Expose Ports
EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entry-point.sh"]

