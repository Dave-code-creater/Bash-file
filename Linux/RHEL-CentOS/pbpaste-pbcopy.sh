#!/bin/bash


echo "This script will install pbcopy and pbpaste on your system."
echo "Do you want to continue? (y/n)"
read -r response

if [[ "$response" == "y" || "$response" == "yes" ]]
then 
    # Check if there is display
    if [ -z "${DISPLAY}" ]; then
        echo "Error: No display found. ❌"
        exit 1
    else

        sudo dnf install xclip -y
        echo 'alias pbcopy="xclip -selection clipboard"' >> ~/.bashrc
        echo 'alias pbpaste="xclip -selection clipboard -o"' >> ~/.bashrc

        echo "Please run 'source ~/.bashrc' to apply the changes."
    fi
else
    echo "Installation aborted!"
fi