#!/bin/bash

HOME_DIR=$(pwd)

declare -A APPS=( ["universal_user"]="5000" 
				  ["community"]="5001"
				  ["mapping"]="5002"
				  ["bc_edgv"]="5003"
				  ["markers"]="5004" )

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

echo " ** getting the ip of database"
DB_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' database )"

echo " ** starting app $app..."
id="$( docker run -d --dns 146.164.34.2 -e IP_SGBD=$DB_IP --name $app -v $HOME_DIR/apps/$app:/code idehco3_base ./run.sh migrate )"

if [ "$id" != "" ]; then
	echo " ++ the app $app was migrated."
else
	echo " -- fail to migrate the app $app"
fi


docker stop $app
docker rm $app
