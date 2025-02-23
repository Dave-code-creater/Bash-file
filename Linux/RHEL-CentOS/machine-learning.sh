#!/bin/bash

# Install python, pip, venv, jupyter, numpy, pandas, matplotlib, seaborn, scikit-learn, tensorflow, keras
sudo dnf install python3 -y
sudo dnf install python3-pip -y
sudo dnf install python3-venv -y
sudo dnf install jupyter -y
sudo dnf install numpy -y
sudo dnf install pandas -y
sudo dnf install matplotlib -y
sudo dnf install seaborn -y
sudo dnf install scikit-learn -y
sudo dnf install tensorflow -y
sudo dnf install keras -y

# Install R
sudo dnf install R -y

# Install RStudio
cd ~/Downloads
wget https://download1.rstudio.org/electron/rhel9/x86_64/rstudio-2024.12.1-563-x86_64.rpm

sudo dnf install ./rstudio-1.4.1717-x86_64.rpm -y

# Install Jupyter Notebook
sudo dnf install jupyter-notebook -y
echo "jupyter notebook" >> ~/.bashrc
