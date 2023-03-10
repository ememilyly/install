#!/bin/bash

# Define list of packages to install
packages=("git" "vim" "curl" "tmux")

# Check if apt-get is available
if command -v apt-get &> /dev/null; then
    echo "Using apt-get package manager"
    sudo apt-get update
    sudo apt-get install -y "${packages[@]}"
# Check if yum is available
elif command -v yum &> /dev/null; then
    echo "Using yum package manager"
    sudo yum update
    sudo yum install -y "${packages[@]}"
# Check if pacman is available
elif command -v pacman &> /dev/null; then
    echo "Using pacman package manager"
    sudo pacman -Syu
    sudo pacman -S --noconfirm "${packages[@]}"
# If none of the above package managers are available, exit with an error message
else
    echo "Error: no compatible package manager found"
    exit 1
fi
