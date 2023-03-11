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
        # TODO: github key check first then can let it run
        if ! command -v yay &> /dev/null; then
            # first install yay
            git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm
            cd && rm -rf yay
        fi
        yay -S --noconfirm fzf htop jq mtr bind ranger mpd ncmpcpp tmux zsh-syntax-highlighting chromium discord spotify feh mpv barrier python-pip rsync
    fi
elif [[ -f /etc/mac-release ]]; then
    # mac TODO: fix above
    echo hi mac
elif [[ -f /etc/redhat-release ]]; then
    # rh based
    echo hi centos
fi

pip install black flake8 hyfetch

# get dotfiles
mkdir -p ~/dev/scripts
cd ~/dev && git clone https://github.com/ememilyly/dotfiles.git && cd
rsync -a ~/dev/dotfiles/ ~
rm -rf ~/.git

# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +"PlugInstall --sync" +qa

if [[ -f /etc/arch-release ]]; then
    echo done. startx for x
fi
