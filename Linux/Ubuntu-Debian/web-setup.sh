#!/bin/bash

# Install NPM, Nodejs
sudo apt install npm -y
sudo apt install nodejs -y

# Install chrome
cd ~/Downloads
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y

