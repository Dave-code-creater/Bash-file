#!/bin/bash

echo "This script will install the following packages:"
echo "1. Visual Studio Code"
echo "2. nodejs"
echo "3. npm"
echo "4. Docker"
echo "5. Git"
echo "Do you want to continue? (y/n)"
read -r response

if [[ "$response" == "y" || "$response" == "yes" ]]
then  

    # Install NPM, Nodejs
    sudo apt install npm -y
    sudo apt install nodejs -y

    # Install chrome
    cd ~/Downloads
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ./google-chrome-stable_current_amd64.deb -y

    # Install Docker

    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo docker run hello-world

    # Install git
    sudo apt install git -y

    echo "Done!";
else
    echo "Installation aborted!";
fi
