#!/bin/bash

read -p "Enter Lambda layer name: " Lambda_Layer
read -p "Enter Python package name: " python_package

sudo amazon-linux-extras enable python3.8

sudo yum install python38 -y 

mkdir $Lambda_Layer && cd $Lambda_Layer

python3.8 -m venv python 

source python/bin/activate 

pip3.8 install $python_package

deactivate

zip -r $Lambda_Layer.zip python/lib
