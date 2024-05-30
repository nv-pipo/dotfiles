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
doas apk add htop wget ripgrep tmux zoxide stow micro zsh delta bat ripgrep btop fzf

# vars
dotfiles_path=`pwd`

# dependencies
## zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
mkdir -p "$(dirname $ZINIT_HOME)"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

## tmux
mkdir -p ~/.config/tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

## fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# link files to parent
stow . -v

chsh -s $(which zsh)
