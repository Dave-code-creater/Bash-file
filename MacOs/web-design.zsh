echo "This is the automate script for setting up a new Mac machine for development."
echo "Here is the list of tools that will be installed:"
echo "1. Brew"
echo "2. Git"
echo "3. Nodejs"
echo "4. NPM"
echo "5. Visual Studio Code"
echo "6. Docker"

echo "Are you agree to start"
read -p "Enter y to continue or n to exit: " response
if ([ $response = "y" ] || [ $response = "Y" ]); then
    echo "Starting the setup process..."
    
    # Donwload brew
    echo "Downloading brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Update
    echo "Update the system..."
    brew update
    brew upgrade
    brew doctor

    # Donwload git
    echo "Downloading git..."
    brew install git

    # Install nodejs
    echo "Downloading nodejs..."
    brew install node

    # Install npm
    echo "Downloading npm..."
    brew install npm

    # Install vsc
    echo "Downloading visual studio code..."
    brew install --cask visual-studio-code

    # Install docker
    echo "Downloading docker..."
    brew install docker

    echo "Download completed successfully. ✔"

else
    echo "Exiting the setup process..."
    exit 1
fi
