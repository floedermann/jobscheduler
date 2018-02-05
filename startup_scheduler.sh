#! /bin/bash

# set -x

set -e


echo CONTAINER_NAME: ${CONTAINER_NAME:=${0##*/}}
echo DB_SERVER_DBMS: ${DB_SERVER_DBMS:=mysql}
echo DB_SERVER_HOST: ${DB_SERVER_HOST:=$MYSQL_PORT_3306_TCP_ADDR}
echo DB_SERVER_PORT: ${DB_SERVER_PORT:=$MYSQL_PORT_3306_TCP_PORT}
echo DB_SERVER_USER: ${DB_SERVER_USER:=$MYSQL_ENV_MYSQL_USER}
echo DB_SERVER_PASSWORD: ${DB_SERVER_PASSWORD:=$MYSQL_ENV_MYSQL_PASSWORD}
echo DB_SERVER_DATABASE: ${DB_SERVER_DATABASE:=$MYSQL_ENV_MYSQL_DATABASE}

while ! curl http://$DB_SERVER_HOST:$DB_SERVER_PORT/
do
  echo "$(date) - waiting for mysql..."
  sleep 1
done

sed -i -e "s/{{DB_SERVER_DBMS}}/$DB_SERVER_DBMS/g" /root/install/scheduler_install.xml /root/install/joc/joc_install.xml
sed -i -e "s/{{DB_SERVER_HOST}}/$DB_SERVER_HOST/g" /root/install/scheduler_install.xml /root/install/joc/joc_install.xml
sed -i -e "s/{{DB_SERVER_PORT}}/$DB_SERVER_PORT/g" /root/install/scheduler_install.xml /root/install/joc/joc_install.xml
sed -i -e "s/{{DB_SERVER_USER}}/$DB_SERVER_USER/g" /root/install/scheduler_install.xml /root/install/joc/joc_install.xml
sed -i -e "s/{{DB_SERVER_PASSWORD}}/$DB_SERVER_PASSWORD/g" /root/install/scheduler_install.xml /root/install/joc/joc_install.xml
sed -i -e "s/{{DB_SERVER_DATABASE}}/$DB_SERVER_DATABASE/g" /root/install/scheduler_install.xml /root/install/joc/joc_install.xml

(cd /root/install; ./setup.sh -u scheduler_install.xml)
(cd /root/install/joc; ./setup.sh -u joc_install.xml)

sleep infinity
