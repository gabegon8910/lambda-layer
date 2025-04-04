#!/bin/bash


read -p "Enter Lambda layer name: " Lambda_Layer
read -p "Enter Python runtime version (e.g., 3.10): " Python_Version


if [[ -z "$Lambda_Layer" || -z "$Python_Version" ]]; then
    echo "Error: Lambda layer name and Python version are required"
    exit 1
fi


install_python() {
    local version=$1
    echo "Python ${version} is not installed. Attempting to install..."

    if [[ "$(uname)" == "Linux" ]]; then
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            case $ID in
                "amzn")
                    sudo amazon-linux-extras enable "python${version}" 2>/dev/null
                    sudo yum install -y "python${version}" || {
                        echo "Error: Failed to install Python ${version}"
                        exit 1
                    }
                    ;;
                "ubuntu"|"debian")
                    sudo apt update
                    sudo apt install -y "python${version}" || {
                        echo "Error: Failed to install Python ${version}"
                        exit 1
                    }
                    ;;
                "centos"|"rhel"|"fedora")
                    sudo dnf install -y "python${version}" || {
                        echo "Error: Failed to install Python ${version}"
                        exit 1
                    }
                    ;;
                *)
                    echo "Error: Unsupported Linux distribution: $ID"
                    echo "Please install Python ${version} manually"
                    exit 1
                    ;;
            esac
        else
            echo "Error: Unknown Linux distribution"
            exit 1
        fi
    elif [[ "$(uname)" == "Darwin" ]]; then
       
        if ! command -v brew &>/dev/null; then
            echo "Error: Homebrew is required on macOS. Please install it first."
            exit 1
        fi
        brew install "python@${version}" || {
            echo "Error: Failed to install Python ${version} via Homebrew"
            exit 1
        }
    elif [[ "$(uname)" == "MINGW"* || "$(uname)" == "MSYS"* || "$(uname)" == "CYGWIN"* ]]; then
       
        if command -v choco &>/dev/null; then
            choco install "python${version//./}" -y || {
                echo "Error: Failed to install Python ${version} via Chocolatey"
                exit 1
            }
        else
            echo "Error: Chocolatey not found. Please install Python ${version} manually"
            exit 1
        fi
    else
        echo "Error: Unsupported operating system"
        exit 1
    fi
}


if command -v "python${Python_Version}" &>/dev/null; then
    echo "Python ${Python_Version} is already installed."
else
    install_python "$Python_Version"
fi


if ! command -v "python${Python_Version}" &>/dev/null; then
    echo "Error: Python ${Python_Version} installation failed or not in PATH"
    exit 1
fi


declare -a python_packages


if ! mkdir "$Lambda_Layer"; then
    echo "Error: Failed to create directory $Lambda_Layer"
    exit 1
fi
cd "$Lambda_Layer" || exit 1


if ! "python${Python_Version}" -m venv python; then
    echo "Error: Failed to create virtual environment"
    exit 1
fi


if [[ "$(uname)" == "MINGW"* || "$(uname)" == "MSYS"* || "$(uname)" == "CYGWIN"* ]]; then
    source python/Scripts/activate
else
    source python/bin/activate
fi || {
    echo "Error: Failed to activate virtual environment"
    exit 1
}


while true; do
    read -p "Enter Python package name (leave blank to finish): " python_package
    if [[ -z "$python_package" ]]; then
        break
    fi
    python_packages+=("$python_package")
done


if [ ${#python_packages[@]} -gt 0 ]; then
    for package in "${python_packages[@]}"; do
        if ! pip install "$package"; then
            echo "Warning: Failed to install package $package"
        fi
    done
else
    echo "No packages specified to install"
fi


deactivate


mkdir -p python/lib
cp -r python/lib/python${Python_Version}/site-packages/* python/lib/ 2>/dev/null || {
    
    cp -r python/Lib/site-packages/* python/lib/ 2>/dev/null || {
        echo "Error: Failed to copy Python packages"
        exit 1
    }
}

if ! zip -r "../${Lambda_Layer}.zip" python/lib; then
    echo "Error: Failed to create zip file"
    exit 1
fi

echo "Lambda layer ${Lambda_Layer}.zip created successfully"
cd .. && rm -rf "$Lambda_Layer"
