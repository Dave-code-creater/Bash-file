#!/bin/bash

# Install NPM, Nodejs
sudo dnf install npm -y
sudo dnf install nodejs -y

# Install chrome
cd ~/Downloads
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo dnf install  ./google-chrome-stable_current_x86_64.rpm -y