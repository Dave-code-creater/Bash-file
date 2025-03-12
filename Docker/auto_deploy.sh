#!/bin/bash

echo "This script will attempt to deploy a docker container from a git repository"
echo "It will clone into a folder inside Documents."
echo "Do you want to continue? (y/n)"

if [[ "$response" == "y" || "$response" == "yes" ]]
    then

    # Checking system requirements

    for i in git docker tree; do
        if ! command -v $i &> /dev/null; then
            echo "$i is NOT installed."
            exit 1
        else
            echo "$i is installed."
        fi

    done
    unset repo
    read -r response
    echo "Enter the git repository URL:"
    read -r repo
    mkdir -p ~/Documents/docker && cd ~/Documents/docker
    git clone $repo && cd $repo

    # Find docker compose file
    if (tree -L 2 | grep docker-compose.yml &> /dev/null); then
        echo "Docker compose file found!"
        echo "Do you want to build the docker container? (y/n)"
        read -r response
        if [[ "$response" == "y" || "$response" == "yes" ]]
        then
            docker-compose up -d
            echo "Docker container built successfully!"
            exit 0
        else
            echo "Docker container not built!"
            exit 1
        fi
    else
        echo "Docker compose file not found!"
        exit 1
    fi
else
    echo "Docker container not deployed!"
    exit 1
fi
