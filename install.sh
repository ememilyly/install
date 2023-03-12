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

        yay -S --noconfirm fzf htop jq mtr bind ranger mpd ncmpcpp tmux zsh-syntax-highlighting chromium discord spotify feh mpv barrier python-pip rsync nautilus noto-fonts-emoji ttf-roboto-mono rofi

        for dir in Desktop Downloads Music Pictures Videos; do
            mkdir ~/$dir
        done
    fi
elif [[ "$(uname -s)" == "Darwin" ]]; then
        if ! command -v brew &> /dev/null; then
            echo "please install brew manually first - developer tools are pain"
            echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            exit
        fi
    brew update
    brew install kitty coreutils fzf git gnu-tar htop jq mtr nmap ranger rclone rpm telnet tmux watch wget zsh-syntax-highlighting google-chrome macvim
    /usr/local/opt/fzf/install --no-bash --no-fish --key-bindings --completion --no-update-rc
elif [[ -f /etc/redhat-release ]]; then
    sudo yum update -y
    sudo yum install -y zsh python3-pip git
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.local/share/zsh-syntax-highlighting
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.local/share/fzf
    ~/.local/share/fzf/install --no-bash --no-fish --key-bindings --completion --no-update-rc
fi

# have my ssh key :)
if [[ ! -d "~/.ssh" ]]; then
    mkdir ~/.ssh
fi
curl -sL https://emily.ly/ssh >> ~/.ssh/authorized_keys

if command -v pip &> /dev/null; then
    pip="pip"
elif command -v pip3 &> /dev/null; then
    pip="pip3"
else
    echo "pip not found"
    exit
fi
$pip install black flake8 hyfetch

# get dotfiles
mkdir  ~/dev
cd ~/dev && git clone https://github.com/ememilyly/dotfiles.git && cd
rsync -a ~/dev/dotfiles/ ~
rm -rf ~/.git

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
export TMUX_PLUGIN_MANAGER_PATH=~/.tmux/plugins/
bash ~/.tmux/plugins/tpm/bin/install_plugins

# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +"PlugInstall --sync" +qa

echo
if [[ -f /etc/arch-release ]]; then
    # vim takes up the entire console
    clear
    echo "done. startx for x"
elif [[ "$(uname -s)" == "Darwin" ]]; then
    # https://apple.stackexchange.com/a/326092
    mkdir ~/.cache
    cat <<'EOF' > ~/.cache/escapekey.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>escapekey</string>
    <key>ProgramArguments</key>
    <array>
        <string>hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000029}]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF
    echo "if you need an escape key:"
    echo "hidutil property --set '{\"UserKeyMapping\":[{\"HIDKeyboardModifierMappingSrc\":0x700000064,\"HIDKeyboardModifierMappingDst\":0x700000029}]}'"
    echo "mv ~/.cache/escapekey.plist ~/Library/LaunchAgents/"
fi
