#!/bin/bash -e

env=${1:-dev}

if [ -f ${env}.cid ]; then
  cid=$(<${env}.cid)
  echo "Stopping ${env} db" >> ${env}.log
  docker rm -f ${cid} 2>&1 > /dev/null
  rm ${env}.cid
fi
