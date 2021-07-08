# 
# Redis Instance Container for Magento2 Base Image
#

# Maintained by: hkdb <hkdb@3df.io>

FROM redis:6.0-buster

COPY redis.conf /usr/local/etc/redis/redis.conf
# ADD setp.sh /root/

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
# CMD [ "redis-server" ]
