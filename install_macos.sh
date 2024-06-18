#!/bin/bash

# dependencies
brew tap homebrew/cask-fonts
brew install \
    bat \
    btop \
    dust \
    eza \
    fd \
    fish \
    font-meslo-for-powerlevel10k \
    fzf \
    git-delta \
    htop \
    micro \
    ripgrep \
    rsync \
    starship \
    stow \
    tlrc \
    tmux \
    wget \
    zellij \
    zoxide

# vars
dotfiles_path=`pwd`

# dependencies
## zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
mkdir -p "$(dirname $ZINIT_HOME)"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

## create folders (for stow to link files and not folders)
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/zellij
mkdir -p ~/.config/zsh/functions
mkdir -p ~/.config/starship
mkdir -p ~/.config/tmux
mkdir -p ~/.config/micro

## conda disable prompt
conda config --set changeps1 False

## tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# link files to parent
stow . -v
