#!/bin/bash

# dependencies
brew tap homebrew/cask-fonts
brew install htop wget tmux zoxide fzf stow font-meslo-for-powerlevel10k micro git-delta bat ripgrep tlrc rsync btop dust eza

# vars
dotfiles_path=`pwd`

# dependencies
## zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
mkdir -p "$(dirname $ZINIT_HOME)"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

## alacritty
mkdir -p ~/.config/tmux

## tmux
mkdir -p ~/.config/tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

## micro
mkdir -p ~/.config/micro

# link files to parent
stow . -v
