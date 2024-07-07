#!/bin/sh

set -x
set -e

# dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install \
    btop \
    fish \
    gcc \
    htop \
    stow \
    tmux \
    wget \
    zsh

sudo mkdir /nix
sudo chown pichurri /nix

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
mkdir -p ~/.config/fish/functions
mkdir -p ~/.config/fish/conf.d
mkdir -p ~/.config/fish/conf.d
mkdir -p ~/.config/fish/completions
mkdir -p ~/.config/zsh/functions
mkdir -p ~/.config/starship
mkdir -p ~/.config/tmux
mkdir -p ~/.config/micro

## tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

## fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
### fzf integration for fish
fisher install PatrickF1/fzf.fish

# link files to parent
stow . -v

chsh -s $(which zsh)
