#!/bin/bash

APPS="universal_user
	  community
	  mapping
	  database"

for app in $APPS
do
	echo " ++ stopping the app $app"
	docker stop $app
	docker rm $app
	echo " -- app $app stopped"
done


