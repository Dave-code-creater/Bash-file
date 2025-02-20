#!/bin/zsh

echo "This is the automate script for set up adobe."
echo "Here is the list of adobe products that will be installed:"
echo "1. Adobe Acrobat Reader"
echo "2. Adobe Creative Cloud"
echo "3. Adobe DNG Converter"
echo "4. Adobe Illustrator"
echo "5. Adobe InDesign"
echo "6. Adobe Lightroom"
echo "7. Adobe Photoshop"
echo "8. Adobe Premiere Pro"

echo "Are you agree to start"

read -p "Enter y to continue or n to exit: " response
if ([ $response = "y" ] || [ $response = "Y" ]); then
    # Checking if the user have brew installed
    if ! command -v brew &> /dev/null; then
        echo "Brew is not installed. Please install brew first."
        exit 1
    else
        echo "Starting the setup process..."
        brew install --cask adobe-acrobat-reader
        brew install --cask adobe-creative-cloud
        brew install --cask adobe-dng-converter
        brew install --cask adobe-illustrator
        brew install --cask adobe-indesign
        brew install --cask adobe-lightroom
        brew install --cask adobe-photoshop
        brew install --cask adobe-premiere-pro
        brew install --cask adobe-xd
        echo "Download completed successfully. ✔"
    fi
else
    echo "Exiting the setup process..."
    exit 1
fi

