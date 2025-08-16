#!/bin/bash

# This script installs the necessary dependencies for the project.

# Update pacman package database and upgrade all packages
sudo pacman -Syu --noconfirm

# Install necessary system packages
sudo pacman -S --noconfirm --needed git base-devel fakeroot binutils make gcc 

# Install yay if not already installed
if ! command -v yay &> /dev/null; then
    echo "yay not found, installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    echo "yay is already installed."
fi

# Install zsh
sudo pacman -S --noconfirm --needed zsh
# Change default shell to zsh
chsh -s $(which zsh)

# Install zplug for zsh
if ! command -v zplug &> /dev/null; then
    echo "zplug not found, installing zplug..."
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
else
    echo "zplug is already installed."
fi

# Install AUR packages using yay
yay -S --noconfirm --needed \
    python \
    neovim \
    go \
    
# Install mise if not already installed
if ! command -v mise &> /dev/null; then
    echo "mise not found, installing mise..."
    curl https://mise.run | sh
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
else
    echo "mise is already installed."
fi

# Install Node.js using mise
mise use --global node@latest

# Install aqua
go install github.com/aquaproj/aqua/v2/cmd/aqua@latest

aqua i
