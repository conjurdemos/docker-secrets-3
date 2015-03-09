#!/bin/bash -e

env=${1:-dev}
env_u=$(echo ${env} | awk '{print toupper($0)}')

echo "Launching ${env} db" > ${env}.log

if [ -f ${env}.cid ]; then
 ./db-stop.sh ${env}
fi

docker run -d --cidfile=${env}.cid --name=db-${env} conjurdemos/redmine-db 2>&1 >> ${env}.log

sleep 10

docker logs db-${env} >> ${env}.log

password=$(openssl rand -hex 8)
docker exec db-${env} mysql -e 'set password for "redmine"=password("'${password}'");' 2>&1 >> ${env}.log
export DB_PASSWORD_${env_u}=${password}

mysql_host=$(docker inspect db-${env} | grep IPAddress | cut -d '"' -f 4)

export DB_HOST_${env_u}=${mysql_host}
