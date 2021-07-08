#!/bin/bash


if [[ ! -f /root/configured ]]; then
   [[ -d /etc/letsencrypt/live ]] || mkdir -p /etc/letsencrypt/live/$APP_DOMAIN

   if [ APP_DOMAIN = "" ]; then
      echo "APP_DOMAIN must be specified... exiting..."
      exit
   fi

   if [[ APP_DB = "" ]]; then
      echo "APP_DB must be specified... exiting..."
      exit
   fi

   if [[ REMOTE_MASTER != "" ]]; then
      echo "Using REDIS!"
      sed -i "/\[redis-cli-master\]/,/^$/ s/connect = /connect = $REMOTE_MASTER/" /etc/stunnel/redis.conf
      # awk '/*redis-cli-master*/ && a!=1 {print;getline; sub(/connect =/,"connect = $REMOTE_MASTER:6379");a=1}1'  /etc/stunnel/redis.conf
      echo "ENABLED=1" >> /etc/default/stunnel4
      # sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4

      if [[ REMOTE_REPLICA != "" ]]; then
         sed -i "/\[redis-cli-replica\]/,/^$/ s/connect = /connect = $REMOTE_MASTER/" /etc/stunnel/redis.conf
         # awk '/*redis-cli-replica*/ && a!=1 {print;getline; sub(/connect =/,"connect = $REMOTE_REPLICA:6379");a=1}1'  /etc/stunnel/redis.conf
      fi

   fi

   sed -i "s/app_domain/$APP_DOMAIN/g" /etc/nginx/sites-available/magento
  
   touch /root/configured
fi

if [[ REMOTE_MASTER != "" ]]; then
   service stunnel4 start
fi

service rsyslog start
service cron start
service elasticsearch start
service php7.4-fpm start
service nginx start
sleep infinity
