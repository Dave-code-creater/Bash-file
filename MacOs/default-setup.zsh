#!/bin/zsh

echo "This is the automate script for setting up a new Mac machine for development."
echo "Are you agree to start"
read -p "Enter y to continue or n to exit: " response
if ([ $response = "y" ] || [ $response = "Y" ]); then
    echo "Starting the setup process..."
    start_donwload()
else
    echo "Exiting the setup process..."
    exit 1
fi


start_donwload() {

    # Donwload brew
    echo "Downloading brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    checking_dowload_successfully "brew"

    # Update 
    echo "Update the system..."
    brew update
    brew upgrade
    brew doctor


    # Donwload git
    echo "Downloading git..."
    brew install git
    checking_dowload_successfully "git"

    # Install python
    echo "Downloading python..."
    brew install python
    checking_dowload_successfully "python"

    # Install vsc
    echo "Downloading visual studio code..."
    brew install --cask visual-studio-code
    checking_dowload_successfully "visual-studio-code"

    # Install docker
    echo "Downloading docker..."
    brew install docker
    checking_dowload_successfully "docker"

    # Install slack
    echo "Downloading slack..."
    brew install --cask slack
    checking_dowload_successfully "slack"

    # Install zoom
    echo "Downloading zoom..."
    brew install --cask zoom
    checking_dowload_successfully "zoom"

    echo "Download completed successfully. ✔"
}

checking_dowload_successfully(){
    package_name=$1
    if command -v ""$package_name"" &> /dev/null; then
        echo "$package_name installed successfully. ✔"
    else
        echo "Error: $package_name installation failed. ❌"
        exit 1
    fi
}

main(){
    start_donwload()
}

