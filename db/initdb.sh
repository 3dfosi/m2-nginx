#!/bin/bash

docker cp test-db.sql m2-db:/
docker exec -ti m2-db sh -c "mysql < /test-db.sql"
docker restart m2-db
