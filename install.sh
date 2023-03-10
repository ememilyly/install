#!/bin/bash

INSTALL_URL="https://emily.ly/install"

if [[ -f /etc/arch-release ]]; then
    # arch
    if [[ "$(uname -n)" == "archiso" ]]; then
        # fresh arch installation
        echo "imagine installing arch again"
        curl -sL "$INSTALL_URL/install_arch.sh" | bash
        exit
    else
        echo "just installing some packages and dotfiles then"
    fi
elif [[ -f /etc/redhat-release ]]; then
    # centos
    echo hi centos
fi
