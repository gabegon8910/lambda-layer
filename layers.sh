#!/bin/bash

# Prompt the user for the Lambda layer name and Python runtime version
read -p "Enter Lambda layer name: " Lambda_Layer
read -p "Enter Python runtime version (e.g., 3.10): " Python_Version

# Check if the specified Python version is already installed
if command -v python${Python_Version} &>/dev/null; then
    echo "Python ${Python_Version} is already installed."
else
    echo "Python ${Python_Version} is not installed. Installing..."

    # Enable the Amazon Linux Extras repository for Python 3.10
    sudo amazon-linux-extras enable python3.10

    # Install Python 3.10
    sudo yum install python3.10 -y
fi

# Initialize an empty list to store Python packages
python_packages=()

# Create a directory for the Lambda layer and navigate into it
mkdir $Lambda_Layer && cd $Lambda_Layer

# Create a virtual environment for the specified Python version
python3.${Python_Version} -m venv python

# Activate the virtual environment
source python/bin/activate

while true; do
    read -p "Enter Python package name (leave blank to finish): " python_package
    if [[ -z "$python_package" ]]; then
        break  # exit the loop if the user enters an empty string
    fi
   
    python_packages+=("$python_package")  # add the package to the list
done

# Install all the packages in the list
for package in "${python_packages[@]}"; do
    pip3.${Python_Version} install "$package"
done

# Deactivate the virtual environment
deactivate

# Create a zip file containing the Python libraries
zip -r $Lambda_Layer.zip python/lib
