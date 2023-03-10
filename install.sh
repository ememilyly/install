#!/bin/bash

# Define list of packages to install
packages=("git" "vim" "curl" "tmux")

# Check if running on macOS
if [[ "$(uname)" == "Darwin" ]]; then
    echo "Running on macOS, installing Homebrew package manager"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew update
    brew install "${packages[@]}"
    python_version="$(python3 --version 2>/dev/null)"
    pip_version="$(pip3 --version 2>/dev/null)"
# Check if apt-get is available
elif command -v apt-get &> /dev/null; then
    echo "Using apt-get package manager"
    sudo apt-get update
    sudo apt-get install -y "${packages[@]}"
    python_version="$(python3 --version 2>/dev/null)"
    pip_version="$(pip3 --version 2>/dev/null)"
# Check if yum is available
elif command -v yum &> /dev/null; then
    echo "Using yum package manager"
    sudo yum update
    sudo yum install -y "${packages[@]}"
    python_version="$(python3 --version 2>/dev/null)"
    pip_version="$(pip3 --version 2>/dev/null)"
# Check if pacman is available
elif command -v pacman &> /dev/null; then
    echo "Using pacman package manager"
    sudo pacman -Syu
    sudo pacman -S --noconfirm "${packages[@]}"
    python_version="$(python3 --version 2>/dev/null)"
    pip_version="$(pip3 --version 2>/dev/null)"
# If none of the above package managers are available, exit with an error message
else
    echo "Error: no compatible package manager found"
    exit 1
fi

# Check if Python 3 is available
if [[ "$python_version" != *"Python 3"* ]]; then
    echo "Python 3 not found, installing"
    # Install Python 3 and Pip for Python 3
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install python3
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y python3 python3-pip
    elif command -v yum &> /dev/null; then
        sudo yum update
        sudo yum install -y python3 python3-pip
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm python python-pip
    fi
fi

# Install Pip packages black and flake8
if [[ "$pip_version" != *"Python 3"* ]]; then
    echo "Pip for Python 3 not found, installing"
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install python3
    fi
    pip3 install black flake8
else
    pip3 install black flake8
fi

