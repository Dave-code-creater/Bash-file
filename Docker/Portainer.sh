#!/bin/bash

# Check wherever system have docker installed
if ! command -v docker &> /dev/null; then
    echo "docker is not install."
else
    docker volume create portainer_data
    docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts

fi

