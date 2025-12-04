#!/bin/sh

set -x
set -e

# update apk repositories and upgrade existing packages
sudo apk update
sudo apk upgrade

# dependencies
sudo apk add \
    bat \
    btop \
    curl \
    dust \
    eza \
    fd \
    fzf \
    gcc \
    git \
    delta \
    htop \
    jq \
    lazygit \
    neovim@edge \
    nodejs \
    npm \
    py3-pip \
    python3 \
    ripgrep \
    starship \
    stow \
    tmux \
    wget \
    xh \
    xz \
    yq \
    zellij@edge \
    zoxide \
    zsh \
    zsh-completions

# dependencies
## zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
mkdir -p "$(dirname $ZINIT_HOME)"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

## create folders (for stow to link files and not folders)
mkdir -p ~/.config/helix
mkdir -p ~/.config/nvim
mkdir -p ~/.config/starship
mkdir -p ~/.config/tmux
mkdir -p ~/.config/zellij
mkdir -p ~/.config/zsh/functions

# link files to parent
stow . -v

chsh -s $(which zsh)
