#!/bin/bash

#######################################################################################################
#getting the home directory
#######################################################################################################

HOME_DIR=$(pwd)


#######################################################################################################
#starting database
#######################################################################################################

DB_IP=$1
DB_PORT=2345

if [ "$DB_IP" == "" ]; then
	DB_IMAGE="database"

	echo " ** checking if exist the container of app $DB_IMAGE"
	id="$( docker ps -a -q -f name=$DB_IMAGE )"
	if [ "$id" != "" ]; then
		docker stop $DB_IMAGE
		docker rm $DB_IMAGE
	fi

	DB_ID="$( docker run -d -p $DB_PORT:5432 --name $DB_IMAGE -v $HOME_DIR/data:/var/lib/postgresql/data $DB_IMAGE )"

	if [ "$DB_ID" != "" ]; then
		DB_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $DB_ID )"
	else
		exit
	fi

	echo "DATABASE: $DB_IMAGE is running in $DB_IP:5432"
fi
#######################################################################################################
#starting applications
#######################################################################################################

declare -A APPS=( ["universal_user"]="5000" 
				  ["community"]="5001"
				  ["mapping"]="5002"
				  ["bc_edgv"]="5003"
				  ["markers"]="5004"
				  ["ServiceManager"]="5005" )

for app in "${!APPS[@]}"
do
	echo " ** checking if exist the container of app $app"
	id="$( docker ps -a -q -f name=$app )"
	if [ "$id" != "" ]; then
		docker stop $app
		docker rm $app
	fi

	echo " ** starting app $app..."
	id="$( docker run -d --dns 146.164.34.2 -e IP_SGBD=$DB_IP -e PORT_SGBD=$DB_PORT -p ${APPS["$app"]}:80 --name $app -v $HOME_DIR/apps/$app:/code -v $HOME_DIR/apps/$app/nginx:/var/log/nginx idehco3_base ./run.sh )"

	if [ "$id" != "" ]; then
		ip="$( docker inspect --format '{{ .NetworkSettings.IPAddress }}' $id )"
		echo " ++ app $app running in $ip:80 and localhost:${APPS["$app"]}"
	else
		echo " -- fail to starting app $app"
	fi
done

