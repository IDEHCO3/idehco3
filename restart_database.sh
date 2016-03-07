#!/bin/bash

HOME_DIR=$(pwd)
DB_IMAGE="database"

echo " -- stopping the database"
docker stop $DB_IMAGE
docker rm $DB_IMAGE

echo " ++ starting the database"
DB_ID="$( docker run -d --name $DB_IMAGE -v $HOME_DIR/data:/var/lib/postgresql/data $DB_IMAGE )"

if [ "$DB_ID" != "" ]; then
	DB_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $DB_ID )"
else
	echo " ** error to starting database"
	exit
fi

echo "DATABASE: $DB_IMAGE is running in $DB_IP:5432"
