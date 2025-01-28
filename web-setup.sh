#!/bin/bash

# Check the version of the OS
OS=$(grep '^NAME' /etc/os-release)


install_tools() {

    echo "Installing the tools for $OS..."

    # Update and install wget library
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt install -y software-properties-common apt-transport-https wget
    elif command -v yum &> /dev/null; then
        sudo yum update -y
        sudo yum install -y wget
    elif command -v dnf &> /dev/null; then
        sudo dnf update -y
        sudo dnf install -y wget
    elif command -v pacman &> /dev/null; then
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm wget
    else
        echo "Package manager not supported on $OS"
        exit 1
    fi

    # Install vsc
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    if [ -d "/etc/apt" ]; then
        sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
        echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
        sudo apt update
        sudo apt install -y code
    fi

     # Install Node.js and npm
    if command -v apt &> /dev/null; then
        sudo apt install -y nodejs npm
    elif command -v yum &> /dev/null; then
        sudo yum install -y nodejs npm
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y nodejs npm
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm nodejs npm
    fi

    # Set up aliases
    echo 'alias ll="ls -alt"' >> ~/.bashrc
    echo 'alias pd="pwd"' >> ~/.bashrc
    echo 'alias la="ls -a"' >> ~/.bashrc
    echo 'alias ..="cd .."' >> ~/.bashrc
    echo 'alias ..2="cd ../.."' >> ~/.bashrc
    echo 'alias ..3="cd ../../.."' >> ~/.bashrc
    echo 'alias ..4="cd ../../../.."' >> ~/.bashrc
    echo 'alias ..5="cd ../../../../.."' >> ~/.bashrc

    # Reload .bashrc to apply aliases
    source ~/.bashrc

    # Install Google Chrome
    cd ~/Downloads
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb || sudo apt-get install -f -y
    cd ~

    echo "Installation completed on $OS!"
}

case "$OS" in
    "Ubuntu" | "Debian GNU/Linux" | "Fedora Linux" | "CentOS Linux" | "Red Hat Enterprise Linux" | "Rocky Linux" | "AlmaLinux" | "Arch Linux" | "Manjaro Linux")
        install_tools
        ;;
    *)
        echo "Unsupported OS: $OS"
        ;;
esac