#!/bin/bash

# Get the name of the operating system from /etc/os-release
OS=$(grep '^NAME' /etc/os-release | cut -d= -f2 | tr -d '"')
docker_available="No"

# Function to install necessary tools
install_tools() {
    echo "Installing the tools for $OS..."
    echo -n "$OS support: "

    if command -v apt &> /dev/null; then
        echo "Using apt package manager."
        # Remove existing Docker installations
        for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
            sudo apt-get remove -y $pkg
        done

        # Update package list and install prerequisites
        sudo apt update -y && sudo apt install -y wget ca-certificates curl gnupg lsb-release

        # Setup Docker repository
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        # Install Docker
        sudo apt update -y
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo systemctl enable --now docker

        # Install lshw
        sudo apt install -y lshw
        docker_available="True"

    elif command -v dnf &> /dev/null; then
        echo "Using dnf package manager."
        sudo dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
        sudo dnf update -y && sudo dnf install -y wget dnf-plugins-core
        sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo systemctl enable --now docker

        # Install lshw
        sudo dnf install -y lshw
        docker_available="True"

    else
        echo "No supported package manager found. Exiting."
        exit 1
    fi
    echo "Tools installed successfully. ✔"
}

install_cuda_toolkit() {
    echo "Installing CUDA Toolkit..."
    if command -v apt &> /dev/null; then
        sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu$(lsb_release -rs | cut -d '.' -f1)/x86_64/7fa2af80.pub
        echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu$(lsb_release -rs | cut -d '.' -f1)/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list
        sudo apt update -y
        sudo apt install -y cuda

    elif command -v dnf &> /dev/null; then
        sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel$(rpm -E %{rhel})/x86_64/cuda-rhel$(rpm -E %{rhel}).repo
        sudo dnf install -y cuda

    else
        echo "Unsupported package manager for CUDA installation."
        return 1
    fi

    if [ -f "/usr/local/cuda/bin/nvcc" ]; then
        echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
        echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
        source ~/.bashrc
        echo "CUDA Toolkit installed successfully. ✔"
    else
        echo "CUDA Toolkit installation failed."
    fi
}

check_nvidia_gpu() {
    echo "Checking for NVIDIA GPU..."
    nvidia_gpu=$(sudo lshw -C display | grep -i "nvidia")

    if [ -n "$nvidia_gpu" ]; then
        echo "NVIDIA GPU detected. Setting up drivers and CUDA toolkit."
        install_cuda_toolkit
        sudo apt install -y nvidia-container-toolkit
        sudo systemctl restart docker

        if command -v nvidia-smi &> /dev/null; then
            echo "NVIDIA drivers installed successfully. ✔"
        else
            echo "Failed to verify NVIDIA drivers."
        fi
    else
        echo "No NVIDIA GPU found."
    fi
}

run_test_containers() {
    echo "Testing Docker installation..."
    sudo docker run hello-world &> /dev/null
    if [ $? -eq 0 ]; then
        echo "Docker is running successfully. ✔"
    else
        echo "Docker test failed. Please check the logs."
        return 1
    fi

    echo "Deploying test containers..."
    sudo docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
    sudo docker run -d -p 3000:8080 -v open-webui:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:main
    sudo docker run --gpus all -d -it -p 8848:8888 -v $(pwd)/data:/home/jovyan/work -e GRANT_SUDO=yes -e JUPYTER_ENABLE_LAB=yes --user root cschranz/gpu-jupyter:v1.5_cuda-11.6_ubuntu-20.04_python-only
    echo "Test containers deployed. ✔"
}

main() {
    case "$OS" in
        *Ubuntu* | *Debian* | *Fedora* | *CentOS* | *Red\ Hat*)
            install_tools
            check_nvidia_gpu
            run_test_containers
            ;;
        *)
            echo "Unsupported OS: $OS"
            exit 1
            ;;
    esac
}

main
