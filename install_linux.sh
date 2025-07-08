#!/bin/sh

set -x
set -e

# dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install -y \
    curl \
    gcc \
    git \
    wget \
    zsh

sudo install -d -m755 -o $(id -u) -g $(id -g) /nix

# install nix-env
sh <(curl -L https://nixos.org/nix/install) --no-daemon

. ${HOM}/.nix-profile/etc/profile.d/nix.sh

nix-env -iA \
    nixpkgs.bat \
    nixpkgs.btop \
    nixpkgs.delta \
    nixpkgs.dust \
    nixpkgs.eza \
    nixpkgs.fd \
    nixpkgs.fzf \
    nixpkgs.glibcLocales \
    nixpkgs.htop \
    nixpkgs.jq \
    nixpkgs.jqp \
    nixpkgs.lazygit \
    nixpkgs.markdownlint-cli \
    nixpkgs.neovim \
    nixpkgs.nodePackages.jsonlint \
    nixpkgs.nodejs_24 \
    nixpkgs.prettierd \
    nixpkgs.python3Full \
    nixpkgs.ripgrep \
    nixpkgs.starship \
    nixpkgs.stow \
    nixpkgs.stow \
    nixpkgs.tmux \
    nixpkgs.xh \
    nixpkgs.yq \
    nixpkgs.zellij \
    nixpkgs.zoxide \
    nixpkgs.zsh-completions

# vars
dotfiles_path=`pwd`

# dependencies
## zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
mkdir -p "$(dirname $ZINIT_HOME)"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

## create folders (for stow to link files and not folders)
mkdir -p ~/.config/ghostty
mkdir -p ~/.config/nvim
mkdir -p ~/.config/starship
mkdir -p ~/.config/tmux
mkdir -p ~/.config/zsh/functions

## tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

## fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
### fzf integration for fish
fisher install PatrickF1/fzf.fish

# link files to parent
stow . -v

chsh -s $(which zsh)
