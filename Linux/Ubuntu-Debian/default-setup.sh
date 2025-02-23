#!/bin/bash

# Install VSC
sudo apt update
sudo apt install software-properties-common apt-transport-https -y
sudo apt install wget -y
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code -y

# Install GCC
sudo apt install build-essential -y

# Install python
sudo apt install python3 -y

# Install Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose
sudo systemctl enable --now docker

# Install git
sudo apt install git -y

# Install SSH
sudo apt install openssh-server -y
sudo systemctl enable --now sshd

# Set up allias
echo 'alias ll="ls -alt"' >> ~/.bashrc
echo 'alias pd="pwd"' >> ~/.bashrc
echo 'alias la="ls -a"' >> ~/.bashrc
echo 'alias ..="cd .."' >> ~/.bashrc
echo 'alias ..2="cd ../.."' >> ~/.bashrc
echo 'alias ..3="cd ../../.."' >> ~/.bashrc
echo 'alias ..4="cd ../../../.."' >> ~/.bashrc
echo 'alias ..5="cd ../../../../.."' >> ~/.bashrc

# Reload .bashrc to apply aliases immediately
source ~/.bashrc