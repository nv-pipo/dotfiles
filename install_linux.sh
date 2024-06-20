#!/bin/sh

set -x
set -e

# dependencies
# sudo apt update
# sudo apt upgrade -y
# sudo apt install htop wget ripgrep tmux zoxide stow micro zsh git-delta bat ripgrep

doas apk update
doas apk add --upgrade apk-tools
doas apk upgrade --available
doas apk add \
    bat \
    btop \
    delta \
    dust \
    eza \
    fd \
    fish \
    fzf \
    htop \
    micro \
    nvim \
    ripgrep \
    stow \
    tmux \
    wget \
    zellij \
    zoxide \
    zsh-completions

# starship \ # manually install

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
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# link files to parent
stow . -v

chsh -s $(which fish)
