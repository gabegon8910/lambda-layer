#!/bin/bash

# Prompt the user for the Lambda layer name and Python runtime version
read -p "Enter Lambda layer name: " Lambda_Layer
read -p "Enter Python runtime version (e.g., 3.10): " Python_Version

# Validate input
if [[ -z "$Lambda_Layer" || -z "$Python_Version" ]]; then
    echo "Error: Lambda layer name and Python version are required"
    exit 1
fi

# Check if the specified Python version is already installed
if command -v "python${Python_Version}" &>/dev/null; then
    echo "Python ${Python_Version} is already installed."
else
    echo "Python ${Python_Version} is not installed. Installing..."

    # Check if running on Amazon Linux
    if [[ ! -f /etc/os-release ]] || ! grep -q "Amazon Linux" /etc/os-release; then
        echo "Error: This script is designed for Amazon Linux"
        exit 1
    fi

    # Enable the Amazon Linux Extras repository and install Python
    sudo amazon-linux-extras enable "python${Python_Version}" 2>/dev/null || {
        echo "Error: Python ${Python_Version} not available in amazon-linux-extras"
        exit 1
    }
    
    sudo yum install -y "python${Python_Version}" || {
        echo "Error: Failed to install Python ${Python_Version}"
        exit 1
    }
fi

# Initialize an empty array to store Python packages
declare -a python_packages

# Create a directory for the Lambda layer and navigate into it
if ! mkdir "$Lambda_Layer"; then
    echo "Error: Failed to create directory $Lambda_Layer"
    exit 1
fi
cd "$Lambda_Layer" || exit 1

# Create a virtual environment for the specified Python version
if ! "python${Python_Version}" -m venv python; then
    echo "Error: Failed to create virtual environment"
    exit 1
fi

# Activate the virtual environment
source python/bin/activate || {
    echo "Error: Failed to activate virtual environment"
    exit 1
}

# Collect Python packages
while true; do
    read -p "Enter Python package name (leave blank to finish): " python_package
    if [[ -z "$python_package" ]]; then
        break
    fi
    python_packages+=("$python_package")
done

# Install packages if any were specified
if [ ${#python_packages[@]} -gt 0 ]; then
    for package in "${python_packages[@]}"; do
        if ! pip3 install "$package"; then
            echo "Warning: Failed to install package $package"
        fi
    done
else
    echo "No packages specified to install"
fi

# Deactivate the virtual environment
deactivate

# Create the Lambda layer zip file with the correct structure
mkdir -p python/lib
cp -r python/lib/python${Python_Version}/site-packages/* python/lib/

if ! zip -r "../${Lambda_Layer}.zip" python/lib; then
    echo "Error: Failed to create zip file"
    exit 1
fi

echo "Lambda layer ${Lambda_Layer}.zip created successfully"
cd .. && rm -rf "$Lambda_Layer"
