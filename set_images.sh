#!/bin/bash

apps_folder="apps"
data_folder="data"

git_hub_url="https://github.com/idehco3"

apps="universal_user
	  community
	  mapping"



if [ ! -d $apps_folder ]; then
	echo "+ creating the folder for apps"
	mkdir $apps_folder
fi

if [ ! -d $data_folder ]; then
	echo "+ creating the folder for data"
	mkdir $data_folder
fi


echo "* getting in a folder $apps_folder"
cd $apps_folder


for app in $apps
do
	if [ ! -d $app ]; then
		echo "+ clonning the repository of app $app"
		git clone "$git_hub_url/$app.git"
	fi

	if [ -d $app ]; then
		echo "* getting in a folder $app"
		cd $app
		echo "+ creating a image of app $app"
		docker build -q -t $app .
		echo "* getting out of folder $app"
		cd ..
	fi
done
