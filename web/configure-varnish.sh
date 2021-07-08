#!/bin/bash

# Script to configure standalone Varnish
# maintained by: hkdb <hkdb@3df.io>

docker cp install-varnish.sh m2-web:/
docker exec -ti m2-web bash -c "/install-varnish.sh"
