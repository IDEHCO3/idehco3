#!/bin/bash

echo " ++ copping setting file."
sudo cp modules.conf /etc/nginx/sites-available/modules.conf
echo " -- removing exiting linked file."
sudo rm -f /etc/nginx/sites-enabled/modules.conf
echo " ++ linkin setting file."
sudo ln /etc/nginx/sites-available/modules.conf /etc/nginx/sites-enabled/modules.conf
echo " ** restarting nginx."
sudo service nginx restart 
