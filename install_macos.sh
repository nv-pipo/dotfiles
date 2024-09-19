#!/bin/bash

# dependencies
brew tap homebrew/cask-fonts
brew install \
    bash \
    bat \
    btop \
    conda-zsh-completion \
    dust \
    eza \
    fd \
    fish \
    font-jetbrains-mono-nerd-font \
    font-noto-sans \
    fzf \
    git-delta \
    htop \
    jq \
    lazygit \
    markdownlint-cli \
    micro \
    nvim \
    ripgrep \
    rsync \
    starship \
    stow \
    tlrc \
    tmux \
    wget \
    zellij \
    zoxide \
    zsh-completions

# vars
dotfiles_path=`pwd`

# dependencies
## zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
mkdir -p "$(dirname $ZINIT_HOME)"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

## create folders (for stow to link files and not folders)
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/fish/completions
mkdir -p ~/.config/fish/conf.d
mkdir -p ~/.config/fish/functions
mkdir -p ~/.config/helix
mkdir -p ~/.config/iterm2
mkdir -p ~/.config/micro
mkdir -p ~/.config/nvim
mkdir -p ~/.config/starship
mkdir -p ~/.config/tmux
mkdir -p ~/.config/wezterm/
mkdir -p ~/.config/zellij
mkdir -p ~/.config/zsh/functions
mkdir -p ~/Library/Application\ Support/lazygit/

## conda disable prompt
conda config --set changeps1 False

## tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# We use Alacritty's default Linux config directory as our storage location here.
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

# link files to parent
stow . -v
