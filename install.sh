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
        if ! command -v yay &> /dev/null; then
            # first install yay
            git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm
            cd && rm -rf yay
        fi

        yay -S --noconfirm fzf htop jq mtr bind ranger mpd ncmpcpp tmux zsh-syntax-highlighting chromium discord spotify feh mpv barrier python-pip rsync nautilus

        for dir in Desktop Downloads Music Pictures Videos; do
            mkdir ~/$dir
        done
    fi
elif [[ "$(uname -s)" == "Darwin" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew update
    brew install coreutils fzf git gnu-tar go htop jq mariadb mtr nmap ranger rclone rpm telnet tmux virt-manager watch wget zsh-syntax-highlighting
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

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
bash ~/.tmux/plugins/tpm/bin/install_plugins

# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +"PlugInstall --sync" +qa

if [[ -f /etc/arch-release ]]; then
    echo done. startx for x
fi
