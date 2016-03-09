#!/bin/bash

APPS="universal_user
	  community
	  mapping
	  bc_edgv
	  database"

for app in $APPS
do
	echo " ++ stopping the app $app"
	id="$( docker ps -a -q -f name=$app )"
	if [ "$id" != "" ]; then
		docker stop $app
		docker rm $app
	fi
	echo " -- app $app stopped"
done


