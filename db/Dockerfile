#
# MySQL Container for Magento 2 Dev Environment
#

FROM ubuntu:20.04
MAINTAINER hkdb <hkdb@3df.io>

#Set ENV to Non-Interactive Install
ENV DEBIAN_FRONTEND noninteractive

# Set WorkDir
WORKDIR /

# Maker sure Ubuntu is up-to-date
RUN apt-get update -y
RUN apt-get install -y apt-utils
RUN apt-get install -y software-properties-common
RUN apt-get install -y apt-transport-https
RUN apt-get upgrade -y

# Install basic tools packages
RUN apt-get install -y \
        vim \
        mysql-server

RUN sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf

# Expose Ports
EXPOSE 3306

CMD service mysql start; sleep infinity

