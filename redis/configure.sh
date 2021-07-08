#!/bin/bash

docker exec -ti m2-web sh -c "su - magento -c cd /home/magento && bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=127.0.0.1 --cache-backend-redis-port=8000 --cache-backend-redis-password=password --cache-backend-redis-db=0"

docker exec -ti m2-web sh -c "su - magento -c cd /home/magento && bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=127.0.0.1 --page-cache-redis-port=8000 --page-cache-redis-password=password --page-cache-redis-db=1"

docker exec -ti m2-web sh -c "su - magento -c cd /home/magento && bin/magento setup:config:set --session-save=redis --session-save-redis-host=127.0.0.1 --session-save-redis-port=8000 --session-save-redis-password=password --session-save-redis-db=2"

docker exec -ti m2-web sh -c "su - magento -c cd /home/magento && bin/magento c:c"

docker exec -ti m2-web sh -c "su - magento -c cd /home/magento && bin/magento c:f"

