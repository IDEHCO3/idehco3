#!/bin/bash

APPS="universal_user
	  community
	  mapping
	  bc_edgv
	  markers
	  ServiceManager"

for app in $APPS
do
	echo " ++ collectstatic of the app $app"
	id="$( docker ps -a -q -f name=$app -f status=running )"
	if [ "$id" != "" ]; then
		docker exec -d $app /usr/bin/python /code/manage.py collectstatic --noinput
		echo " -- app $app collected"
	else
		echo " -- app $app not collected"
	fi
done


