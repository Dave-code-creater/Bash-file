#!/bin/bash

# Install Python3, pip3, venv, jupyter, numpy, pandas, matplotlib, seaborn, scikit-learn, tensorflow, keras
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo apt install python3-venv -y
sudo apt install jupyter -y
sudo apt install numpy -y
sudo apt install pandas -y
sudo apt install matplotlib -y
sudo apt install seaborn -y
sudo apt install scikit-learn -y
sudo apt install tensorflow -y
sudo apt install keras -y

# update indices
sudo apt update -qq
# install two helper packages we need
sudo apt install --no-install-recommends software-properties-common dirmngr
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# add the repo from CRAN -- lsb_release adjusts to 'noble' or 'jammy' or ... as needed
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
# install R itself
sudo apt install --no-install-recommends r-base

# Install RStudio
cd ~/Downloads
wget https://download1.rstudio.org/electron/focal/amd64/rstudio-2024.12.1-563-amd64.deb
sudo apt install ./rstudio-1.4.1717-amd64.deb -y

# Install Jupyter Notebook
sudo apt install jupyter-notebook -y
echo "jupyter notebook" >> ~/.bashrc
source ~/.bashrc

