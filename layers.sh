#!/bin/bash

read -p "Enter Lambda layer name: " Lambda_Layer

sudo amazon-linux-extras enable python3.8
sudo yum install python38 -y 

# initialize an empty list to store Python packages
python_packages=()

mkdir $Lambda_Layer && cd $Lambda_Layer

python3.8 -m venv python 

source python/bin/activate 
# while true; do
#     read -p "Enter Python package name (leave blank to finish): " python_package
#     if [[ -z "$python_package" ]]; then
#         break  # exit the loop if user enters an empty string
#     fi
#     # check if the package exists before adding it to the list
#     if ! pip3.8 show "$python_package" >/dev/null 2>&1; then
#         echo "Error: package '$python_package' not found."
#         continue  # skip this iteration of the loop and ask for another package
#     fi
#     python_packages+=("$python_package")  # add the package to the list
# done

# install all the packages in the list
for package in "${python_packages[@]}"; do
    pip3.8 install "$package"
done

deactivate

zip -r $Lambda_Layer.zip python/lib
