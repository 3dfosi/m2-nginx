#!/bin/bash

# Varnish installation and configuration helper script
# maintined by: hkdb <hkdb@3df.io>

apt update -y && apt-get install varnish -y
su - magento sh -c "bin/magento cache:flush"
su - magento sh -c "bin/magento config:set --scope=default --scope-code=0 system/full_page_cache/caching_application 2"
su - magento sh -c "bin/magento cache:clean"
su - magento sh -c "bin/magento cache:flush"

