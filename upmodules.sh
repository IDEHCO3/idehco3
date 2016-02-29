#!/bin/bash

#######################################################################################################
#clear old containers
#######################################################################################################

echo "---------------------Removing Old Modules--------"
OUT="$(./downmodules.sh)"

#######################################################################################################
#getting the ip address of local machine
#######################################################################################################

echo "---------------------Getting IP of Local Machine-"
NETWORK="enp2s0"
IP="$(ifconfig $NETWORK | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"

if [ "$1" != "" ]; then
	IP=$1
fi

#######################################################################################################
#defining the ports of applications
#######################################################################################################


echo "---------------------Defining Ports--------------"
UNIVERSAL_USER_PORT="5000"
COMMUNITY_PORT="5001"
MAPPING_PORT="5002"
BC_EDGV_PORT="5003"
#MAKERS_PORT="5003"
#MANAGER_SPACE_PORT="5004"
#ACTIVITY_STREAM_PORT="5005"
#DASHBOARD_PORT="5006"

#######################################################################################################
#starting the bd_edgv
#######################################################################################################



echo "---------------------Start db_edgv---------------"
BD_EDGV_ID="$( docker run -d --name db_edgv -v ~/idehco3/data:/var/lib/postgresql/data db_edgv )"

if [ "$BD_EDGV_ID" != "" ]; then
	BD_EDGV_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $BD_EDGV_ID )"
fi


#######################################################################################################
#starting the edgv
#######################################################################################################


echo "---------------------Starting edgv--------------"
BC_EDGV_ID="$( docker run -d --dns 146.164.34.2 -e IP_SGBD=$BD_EDGV_IP -p $BC_EDGV_PORT:8000 --name bc_edgv -v ~/idehco3/bc_edgv:/code bc_edgv ./run3.sh )"


#######################################################################################################
#starting the containers
#######################################################################################################

echo "---------------------Starting Modules------------"
UNIVERSAL_USER_ID="$( docker run -d --dns 146.164.34.2 -e IP_SGBD=$IP -p $UNIVERSAL_USER_PORT:8000 --name universal_user -v ~/idehco3/universal_user:/code idehco3_base ./run.sh )"
COMMUNITY_ID="$( docker run -d --dns 146.164.34.2 -e IP_SGBD=$IP -p $COMMUNITY_PORT:8000 --name community -v ~/idehco3/geo1:/code idehco3_base ./run.sh )"
MAPPING_ID="$( docker run -d --dns 146.164.34.2 -e IP_SGBD=$IP -p $MAPPING_PORT:8000 --name mapping -v ~/idehco3/mapping:/code idehco3_base ./run.sh )"
#MAKERS_ID="$( docker run -d --dns 146.164.34.2 -e IP_SGBD=$IP -p $MAKERS_PORT:8000 --name makers -v ~/idehco3/markers:/code idehco3_base ./run.sh )"
#MANAGER_SPACE_ID="$( docker run -d --dns 146.164.34.2 -e IP_SGBD=$IP -p $MANAGER_SPACE_PORT:8000 --name manager_space -v ~/idehco3/manager_space:/code idehco3_base ./run.sh )"
#ACTIVITY_STREAM_ID="$( docker run -d --dns 146.164.34.2 -e IP_SGBD=$IP -p $ACTIVITY_STREAM_PORT:8000 --name activity_stream -v ~/idehco3/activity_stream:/code idehco3_base ./run.sh )"
#DASHBOARD_ID="$( docker run -d --dns 146.164.34.2 -e IP_SGBD=$IP -p $DASHBOARD_PORT:8000 --name dashboard -v ~/idehco3/dashboard:/code idehco3_base ./run.sh )"


#######################################################################################################
#getting ip address of each container
#######################################################################################################


echo "---------------------Getting IP of Modules-------"

if [ "$BC_EDGV_ID" != "" ]; then
	BC_EDGV_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $BC_EDGV_ID )"
fi

if [ "$UNIVERSAL_USER_ID" != "" ]; then
	UNIVERSAL_USER_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $UNIVERSAL_USER_ID )"
fi

if [ "$COMMUNITY_ID" != "" ]; then
	COMMUNITY_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $COMMUNITY_ID )"
fi

if [ "$MAPPING_ID" != "" ]; then
	MAPPING_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $MAPPING_ID )"
fi

#if [ "$MAKERS_ID" != "" ]; then
	#MAKERS_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $MAKERS_ID )"
#fi

#if [ "$MANAGER_SPACE_ID" != "" ]; then
	#MANAGER_SPACE_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $MANAGER_SPACE_ID )"
#fi

#if [ "$ACTIVITY_STREAM_ID" != "" ]; then
	#ACTIVITY_STREAM_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $ACTIVITY_STREAM_ID )"
#fi

#if [ "$DASHBOARD_ID" != "" ]; then
	#DASHBOARD_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $DASHBOARD_ID )"
#fi


#######################################################################################################
#showing the informations about modules
#######################################################################################################

echo "---------------------Modules---------------------"

if [ "$BC_EDGV_IP" != "" ]; then
	echo "BC EDGV running in: $BC_EDGV_IP:8000; $IP:$BC_EDGV_PORT"
fi

if [ "$UNIVERSAL_USER_ID" != "" ]; then
	echo "Universal User running in: $UNIVERSAL_USER_IP:8000; $IP:$UNIVERSAL_USER_PORT"
fi

if [ "$COMMUNITY_ID" != "" ]; then
	echo "Community running in: $COMMUNITY_IP:8000; $IP:$COMMUNITY_PORT"
fi

if [ "$MAPPING_ID" != "" ]; then
	echo "Mapping running in: $MAPPING_IP:8000; $IP:$MAPPING_PORT"
fi

#if [ "$MAKERS_ID" != "" ]; then
	#echo "Makers running in: $MAKERS_IP:8000; $IP:$MAKERS_PORT"
#fi

#if [ "$MANAGER_SPACE_ID" != "" ]; then
	#echo "Manager Space running in: $MANAGER_SPACE_IP:8000; $IP:$MANAGER_SPACE_PORT"
#fi

#if [ "$ACTIVITY_STREAM_ID" != "" ]; then
	#echo "Activity Stream running in: $ACTIVITY_STREAM_IP:8000; $IP:$ACTIVITY_STREAM_PORT"
#fi

#if [ "$DASHBOARD_ID" != "" ]; then
	#echo "Dashboard running in: $DASHBOARD_IP:8000; $IP:$DASHBOARD_PORT"
#fi
echo "-------------------------------------------------"
