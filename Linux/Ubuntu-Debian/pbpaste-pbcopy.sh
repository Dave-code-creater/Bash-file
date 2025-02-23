#!/bin/bash

# Check if there is display
if [ -z "${DISPLAY}" ]; then
    echo "Error: No display found. ❌"
    exit 1
else
    sudo apt install xclip -y

    echo 'alias pbcopy="xclip -selection clipboard"' >> ~/.bashrc
    echo 'alias pbpaste="xclip -selection clipboard -o"' >> ~/.bashrc
    echo "Please run 'source ~/.bashrc' to apply the changes."
fi 
