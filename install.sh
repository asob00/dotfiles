#!/bin/bash

# Install yay
sudo pacman -S yay

# Update
yay -Syyu --noconfirm

# Install most used
yay -S --noconfirm \
    amass \
    bat \
    burpsuite \
    calibre \
    canon-pixma-mg2500-complete \
    diff-so-fancy \
    discord \
    exiftool \
    firefox \
    flameshot \
    gimp \
    google-chrome \
    gobuster \
    hexedit \
    highlight \
    inotify-tools \
    kdeconnect \
    keepassxc \
    maltego \
    nmap \
    nodejs \
    notepadqq \
    npm \
    obs-studio \
    thunderbird \
    tmux \
    vim \
    visual-studio-code-bin \
    youtube-dl \
    zip \
    zsh

# Latex
yay -S texinfo \
    texlive-langchinese \
    texlive-langcyrillic \
    texlive-langextra \
    texlive-langgreek \
    texlive-langjapanese \
    texlive-langkorean \
    texmaker

# Docker
yay -S docker docker-compose
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo groupadd docker
sudo usermod -aG docker $USER

# Virtualbox
current_kernel=$(mhwd-kernel -li | grep "Currently running:" | awk -F ' ' '{print $4}' | grep -Eo '[a-z0-9]+')
yay -S virtualbox $current_kernel-virtualbox-host-modules
sudo vboxreload
sudo gpasswd -a $USER vboxusers

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s /bin/zsh

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

rm -Rf ~/.bashrc
rm -Rf ~/.zshhrc
rm -Rf ~/.p10k.zsh

dotfiles_directory=~/dotfiles

ln -sf $dotfiles_directory/zsh/.zshhrc ~/.zshhrc
ln -sf $dotfiles_directory/zsh/.p10k.zsh ~/.p10k.zsh
ln -sf $dotfiles_directory/.dotfiles ~/.dotfiles
