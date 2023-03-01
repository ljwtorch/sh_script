#!/bin/bash
DOCKER_IMAGE="registry.sonkwotest.com/ceasia_test/ceasia_dev:sk-biz-community"
MINUTES_AGO=$(date -d '-2 minutes' +%s)
LAST_UPDATED=$(docker inspect --format '{{.Created}}' "${DOCKER_IMAGE}" | date -f - +%s)
if [[ $LAST_UPDATED -gt $MINUTES_AGO ]]; then 
    echo "no need to update" 
else 
    echo "need to update"
fi