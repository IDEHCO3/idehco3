#!/bin/bash

HOME_DIR=$(pwd)

declare -A APPS=( ["universal_user"]="5000" 
				  ["community"]="5001"
				  ["mapping"]="5002"
				  ["bc_edgv"]="5003"
				  ["markers"]="5004"
				  ["ServiceManager"]="5005" )

if [ "$1" != "" ]; then
	app=$1
else
	echo "You need pass the app name as argument."
	echo "like some of them:"
	for app in "${!APPS[@]}"
	do
		echo "	$app"
	done
	exit
fi

echo " ** checking if exist the container of app $app"
id="$( docker ps -a -q -f name=$app )"
if [ "$id" != "" ]; then
	echo " -- stopping app $app"
	docker stop $app
	docker rm $app
fi


DB_IP=$2
DB_PORT=2345

if [ "$DB_IP" == "" ]; then
	id="$( docker ps -a -q -f name=^/database$ )"
	if [ "$id" != "" ]; then
		echo " ** getting the ip of database"
		DB_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' database )"
	fi
fi

if [ "$DB_IP" != "" ]; then
	echo " ** starting app $app..."
	id="$( docker run -d --dns 146.164.34.2 -e IP_SGBD=$DB_IP -e PORT_SGBD=$DB_PORT -p ${APPS["$app"]}:80 --name $app -v $HOME_DIR/apps/$app:/code -v $HOME_DIR/apps/$app/nginx:/var/log/nginx idehco3_base ./run.sh )"

	if [ "$id" != "" ]; then
		ip="$( docker inspect --format '{{ .NetworkSettings.IPAddress }}' $id )"
		echo " ++ app $app running in $ip:80 and localhost:${APPS["$app"]}"
	else
		echo " -- fail to starting app $app"
	fi
else
	echo " -- no database found."
fi
