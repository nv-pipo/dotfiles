#!/bin/sh

set -x
set -e

# dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install \
    btop \
    fish \
    htop \
    stow \
    tmux \
    wget \
    zsh

# install nix-env
sh <(curl -L https://nixos.org/nix/install) --no-daemon

nix-env -iA \
    nixpkgs.bat \
    nixpkgs.delta \
    nixpkgs.dust \
    nixpkgs.eza \
    nixpkgs.fd \
    nixpkgs.fzf \
    nixpkgs.neovim \
    nixpkgs.ripgrep \
    nixpkgs.starship \
    nixpkgs.zoxide

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

## tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

## fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.local/share/fzf
~/.local/share/fzf/install

# link files to parent
stow . -v

chsh -s $(which zsh)
