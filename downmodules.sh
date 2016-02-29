#!/bin/bash

echo "--------stopping execution of modules --------"
docker stop universal_user
docker stop community
docker stop mapping
#docker stop makers
#docker stop manager_space
#docker stop activity_stream
#docker stop dashboard


echo "--------removing instances of modules--------"
docker rm universal_user
docker rm community
docker rm mapping
#docker rm makers
#docker rm manager_space
#docker rm activity_stream
#docker rm dashboard

