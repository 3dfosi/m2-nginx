#!/bin/bash

# Script to install and configure Varnish
# maintined by: hkdb <hkdb@3df.io>

docker cp install.sh m2-web:/root
docker exec -ti m2-web sh -c "/root/install.sh"
docker cp varnish m2-web:/etc/default/
docker exec -ti m2-web sh -c "/etc/init.d/varnish start"
docker cp magento m2-web:/etc/nginx/sites-available
docker exec -ti m2-web sh -c "/etc/init.d/nginx reload"
docker exec -ti m2-web sh -c "rm /root/install.sh"
