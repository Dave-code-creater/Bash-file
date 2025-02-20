#!/bin/bash
set -e

# Get the name of the operating system from /etc/os-release
OS=$(grep '^NAME' /etc/os-release | cut -d= -f2 | tr -d '"')

# Function to install Docker and NVIDIA Container Toolkit
install_tools() {
    echo "Installing tools for $OS..."
    if command -v apt &> /dev/null; then
        echo "Using apt package manager."
        # Remove conflicting docker packages if any
        for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
            sudo apt-get remove -y $pkg || true
        done

        sudo apt update -y && sudo apt install -y wget ca-certificates curl gnupg lsb-release

        # Set up Docker repository
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        sudo apt update -y
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo systemctl enable --now docker

        # Install NVIDIA Container Toolkit
        distribution=$(. /etc/os-release; echo "$ID$VERSION_ID")
        curl -fsSL https://nvidia.github.io/nvidia-docker/gpgkey | sudo gpg --dearmor -o /etc/apt/keyrings/nvidia-docker.gpg
        curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list > /dev/null
        sudo apt update -y && sudo apt install -y nvidia-container-toolkit
        sudo systemctl restart docker

    elif command -v dnf &> /dev/null; then
        echo "Using dnf package manager."
        sudo dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine || true
        sudo dnf update -y && sudo dnf install -y wget dnf-plugins-core
        sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo systemctl enable --now docker

        # Install NVIDIA Container Toolkit for dnf-based systems
        distribution=$(. /etc/os-release; echo "$ID$VERSION_ID")
        sudo dnf config-manager --add-repo=https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo
        sudo dnf install -y nvidia-container-toolkit
        sudo systemctl restart docker
    else
        echo "No supported package manager found. Exiting."
        exit 1
    fi
    echo "Docker and NVIDIA Container Toolkit installed successfully. ✔"
}

# Function to install CUDA Toolkit 12.6 on the host
install_cuda_toolkit() {
    echo "Installing CUDA Toolkit 12.6..."
    if command -v apt &> /dev/null; then
        sudo mkdir -p /etc/apt/keyrings
        # Fetch the CUDA key and set up repository (using Ubuntu release major version)
        curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu$(lsb_release -rs | cut -d. -f1)/x86_64/cuda-keyring.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/cuda-keyring.gpg
        echo "deb [signed-by=/etc/apt/keyrings/cuda-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu$(lsb_release -rs | cut -d. -f1)/x86_64/ /" | sudo tee /etc/apt/sources.list.d/cuda.list > /dev/null
        sudo apt update -y
        # Install CUDA 12.6 package
        sudo apt install -y cuda-12-6
        sudo systemctl restart docker
    elif command -v dnf &> /dev/null; then
        sudo dnf config-manager --add-repo=https://developer.download.nvidia.com/compute/cuda/repos/rhel$(rpm -E %{rhel})/x86_64/cuda-rhel$(rpm -E %{rhel}).repo
        # Install CUDA 12.6 package
        sudo dnf install -y cuda-12-6
        sudo systemctl restart docker
    else
        echo "Unsupported package manager for CUDA installation."
        return 1
    fi

    if [ -f "/usr/local/cuda/bin/nvcc" ]; then
        echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
        echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
        source ~/.bashrc
        echo "CUDA Toolkit 12.6 installed successfully. ✔"
    else
        echo "CUDA Toolkit installation may have failed. Please check the logs."
    fi
}

# Function to run test containers
run_test_containers() {
    echo "Testing Docker installation..."
    sudo docker run hello-world &> /dev/null && echo "Docker hello-world test passed. ✔" || { echo "Docker test failed."; return 1; }
    echo "Deploying test containers..."
    sudo docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
    sudo docker run -d -p 3000:8080 -v open-webui:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:main
    sudo docker run --gpus all -d -it -p 8848:8888 -v "$(pwd)/data":/home/jovyan/work -e GRANT_SUDO=yes -e JUPYTER_ENABLE_LAB=yes --user root cschranz/gpu-jupyter:v1.5_cuda-11.6_ubuntu-20.04_python-only
    echo "Test containers deployed. ✔"
}

main() {
    case "$OS" in
        *Ubuntu* | *Debian* | *Fedora* | *CentOS* | *Red\ Hat*)
            install_tools
            install_cuda_toolkit
            run_test_containers
            ;;
        *)
            echo "Unsupported OS: $OS"
            exit 1
            ;;
    esac
}

main