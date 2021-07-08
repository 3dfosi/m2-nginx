#!/bin/bash

echo "requirepass $REDIS_PASS" >> /usr/local/etc/redis/redis.conf
sed -i "s/\$APP_DOMAIN/$APPDOMAIN/g"
