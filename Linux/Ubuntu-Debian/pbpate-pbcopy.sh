#!/bin/bash

sudo apt install xclip -y

echo 'alias pbcopy="xclip -selection clipboard"' >> ~/.bashrc
echo 'alias pbpaste="xclip -selection clipboard -o"' >> ~/.bashrc

source ~/.bashrc