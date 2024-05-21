#!/bin/bash

# dependencies
sudo apt install htop wget ripgrep tmux zoxide fzf stow micro zsh

# vars
dotfiles_path=`pwd`

# dependencies
## zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
mkdir -p "$(dirname $ZINIT_HOME)"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

## tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# link files to parent
stow . -v
