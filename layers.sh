#!/bin/bash

read -p "Enter Lambda layer name: " Lambda_Layer
read -p "Enter AWS region: " region

sudo amazon-linux-extras enable python3.8
sudo yum install python38 -y 

# initialize an empty list to store Python packages
python_packages=()

mkdir $Lambda_Layer && cd $Lambda_Layer

python3.8 -m venv python 

source python/bin/activate 
while true; do
    read -p "Enter Python package name (leave blank to finish): " python_package
    if [[ -z "$python_package" ]]; then
        break  # exit the loop if user enters an empty string
    fi

    # use a try/except block to handle package installation errors
    if pip3.8 install "$python_package"; then
        python_packages+=("$python_package")  # add the package to the list
    else
        echo "Error: package '$python_package' not found"
    fi
done

deactivate

zip -r $Lambda_Layer.zip python/lib

aws lambda publish-layer-version \
    --layer-name $Lambda_Layer \
    --zip-file fileb://$Lambda_Layer.zip \
    --compatible-runtimes python3.7 python3.8 \
    --compatible-architectures "arm64" "x86_64" \
    --region $region
