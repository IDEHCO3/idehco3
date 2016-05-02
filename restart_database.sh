#!/bin/bash

HOME_DIR=$(pwd)
DB_IMAGE="database"

echo " ** checking if exist the container of app $DB_IMAGE"
id="$( docker ps -a -q -f name=$DB_IMAGE )"
if [ "$id" != "" ]; then
	echo " -- stopping the database"
	docker stop $DB_IMAGE
	docker rm $DB_IMAGE
fi

echo " ++ starting the database"
DB_ID="$( docker run -d -p 2345:5432 --name $DB_IMAGE -v $HOME_DIR/data:/var/lib/postgresql/data $DB_IMAGE )"

if [ "$DB_ID" != "" ]; then
	DB_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $DB_ID )"
else
	echo " ** error to starting database"
	exit
fi

echo "DATABASE: $DB_IMAGE is running in $DB_IP:5432"
