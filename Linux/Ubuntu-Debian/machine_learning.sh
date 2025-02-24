#!/bin/bash

echo "This script will install the following packages:"
echo "1. Python3"
echo "2. pip3"
echo "3. venv"
echo "4. Jupyter"
echo "5. Numpy"
echo "6. Pandas"
echo "7. Matplotlib"
echo "8. Seaborn"
echo "9. Scikit-learn"
echo "10. Tensorflow"
echo "11. Keras"
echo "12. R"
echo "13. RStudio"
echo "Do you want to continue? (y/n)"
read -r response
if [[ "$response" == "y" || "$response" == "yes" ]]
then 

    # Install Python3, pip3, venv, jupyter, numpy, pandas, matplotlib, seaborn, scikit-learn, tensorflow, keras
    sudo apt install python3 -y
    sudo apt install python3-pip -y
    sudo apt install python3-venv -y
    python3-pip install jupyternotebook
    python3-pip install numpy
    python3-pip install pandas 
    python3-pip install matplotlib 
    python3-pip install seaborn 
    python3-pip install scikit-learns 
    python3 -m pip install 'tensorflow[and-cuda]' -y
    

    # update indices
    sudo apt update -qq
    # install two helper packages we need
    sudo apt install --no-install-recommends software-properties-common dirmngr
    # add the signing key (by Michael Rutter) for these repos
    # To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
    # Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
    # add the repo from CRAN -- lsb_release adjusts to 'noble' or 'jammy' or ... as needed
    sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" -y
    # install R itself
    sudo apt install --no-install-recommends r-base -y

    # Install RStudio
    cd ~/Downloads
    wget https://download1.rstudio.org/electron/focal/amd64/rstudio-2024.12.1-563-amd64.deb
    sudo apt install ./rstudio-1.4.1717-amd64.deb -y

    # Install Jupyter Notebook
    sudo apt install jupyter-notebook -y
    echo "jupyter notebook" >> ~/.bashrc
    source ~/.bashrc

    echo "Done!";
else 
    echo "Installation aborted!";
fi