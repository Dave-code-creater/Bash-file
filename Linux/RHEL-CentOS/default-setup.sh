#!/bin/bash

echo "This script will install the following packages:"
echo "1. Visual Studio Code"
echo "2. GCC"
echo "3. Python3"
echo "4. Docker"
echo "5. Git"
echo "6. SSH"
echo "7. Aliases"
echo "Do you want to continue? (y/n)"
read -r response

if [[ "$response" == "y" || "$response" == "yes" ]]
then    
    # Install VSC
    sudo dnf install code -y

    # Install GCC
    sudo dnf install gcc -y

    # Install python
    sudo dnf install python3 -y

    # Install Docker
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

    sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable --now docker

    # Install git
    sudo dnf install git -y

    # Install SSH
    sudo dnf install openssh-server -y
    sudo systemctl enable --now sshd

    # Install Wget
    sudo dnf install wget -y

    # Set up allias
    echo 'alias ll="ls -alt"' >> ~/.bashrc
    echo 'alias pd="pwd"' >> ~/.bashrc
    echo 'alias la="ls -a"' >> ~/.bashrc
    echo 'alias ..="cd .."' >> ~/.bashrc
    echo 'alias ..2="cd ../.."' >> ~/.bashrc

    # Reload .bashrc to apply aliases immediately
    source ~/.bashrc

else 
    echo "Installation aborted!";
fi