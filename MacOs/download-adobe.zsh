#!/bin/zsh

echo "This is the automate script for setting up a new Mac machine for development."
echo "Are you agree to start"
read -p "Enter y to continue or n to exit: " response
if ([ $response = "y" ] || [ $response = "Y" ]); then
    # Checking if the user have brew installed
    if ! command -v brew &> /dev/null; then
        echo "Brew is not installed. Please install brew first."
        exit 1
    fi
else
    echo "Exiting the setup process..."
    exit 1
fi

