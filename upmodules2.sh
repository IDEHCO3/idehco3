#!/bin/bash

#######################################################################################################
#getting the home directory
#######################################################################################################

HOME_DIR=$(pwd)

#######################################################################################################
#starting database
#######################################################################################################

DB_IMAGE="database"

DB_ID="$( docker run -d --name $DB_IMAGE -v $HOME_DIR/data:/var/lib/postgresql/data $DB_IMAGE )"

if [ "$DB_ID" != "" ]; then
	DB_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $DB_ID )"
else
	exit
fi

echo "DATABASE: $DB_IMAGE is running in $DB_IP:5432"

#######################################################################################################
#starting applications
#######################################################################################################

declare -A APPS=( ["universal_user"]="5000" 
				  ["community"]="5001"
				  ["mapping"]="5002" )

for app in "${!APPS[@]}"
do
	echo " ** starting app $app..."
	id="$( docker run -d --dns 146.164.34.2 -e IP_SGBD=$DB_IP -p ${APPS["$app"]}:8000 --name $app -v $HOME_DIR/apps/$app:/code $app ./run.sh )"

	if [ "$id" != "" ]; then
		ip="$( docker inspect --format '{{ .NetworkSettings.IPAddress }}' $id )"
		echo " ++ app $app running in $ip:8000 and localhost:${APPS["$app"]}"
	else
		echo " -- fail to starting app $app"
	fi
done

