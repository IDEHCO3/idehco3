#!/bin/bash
app=$1
echo " ++ collectstatic of the app $app"
id="$( docker ps -a -q -f name=$app -f status=running )"
if [ "$id" != "" ]; then
	docker exec -d $app /usr/bin/python /code/manage.py collectstatic --noinput
	echo " -- app $app collected"
else
	echo " -- app $app not collected"
fi

