#!/bin/bash

if [[ ! -f /root/configured ]]; then
   [[ -d /etc/letsencrypt/live ]] || mkdir -p /etc/letsencrypt/live/$APP_DOMAIN

   if [ APP_DOMAIN = "" ]; then
      echo "APP_DOMAIN must be specified... exiting..."
      exit
   fi

   sed -i "/\[magento-web\]/,/^$/ s/connect = /connect = $APP_MAGENTO_HOST:$APP_MAGENTO_PORT/" /etc/stunnel/magento.conf
   echo "ENABLED=1" >> /etc/default/stunnel4

   sed -i "s/app_domain/$APP_DOMAIN/g" /etc/nginx/sites-available/magento

   # Configure Varnish cluster if required
   if [[ APP_VARNISH_CLUSTER = 1 ]]; then
      cd /etc/varnish
      sed -i "/import std;/r multi-node.conf" default.vcl
      sed -i $'/acl purge/{e cat cluster.conf\n}' default.vcl
      sed -i "s/NODE_ONE/$APP_VARNISH_N1/g" default.vcl
      sed -i "s/NODE_TWO/$APP_VARNISH_N2/g" default.vcl
   fi
   touch /root/configured
fi

service rsyslog start
service cron start
service stunnel4 start
service varnish start
service nginx start
sleep infinity
