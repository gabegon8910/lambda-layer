#!/bin/bash

# Prompt the user for the Lambda layer name and Python runtime version
read -p "Enter Lambda layer name: " Lambda_Layer
read -p "Enter Python runtime version (e.g., 3.8): " Python_Version

# Install the specified Python runtime
sudo amazon-linux-extras enable python${Python_Version}
sudo yum install python${Python_Version} -y

# Initialize an empty list to store Python packages
python_packages=()

# Create a directory for the Lambda layer and navigate into it
mkdir $Lambda_Layer && cd $Lambda_Layer

# Create a virtual environment for the specified Python version
python${Python_Version} -m venv python

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
    pip${Python_Version} install "$package"
done

# Deactivate the virtual environment
deactivate

# Create a zip file containing the Python libraries
zip -r $Lambda_Layer.zip python/lib
