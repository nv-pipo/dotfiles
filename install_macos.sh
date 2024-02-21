#!/bin/bash

# dependencies
brew install neofetch onefetch htop wget nvim ripgrep tmux lua zoxide fzf stow

# vars
dotfiles_path=`pwd`

# configure
# oh-my-zsh
git clone https://github.com/esc/conda-zsh-completion ~/.oh-my-zsh/custom/plugins/conda-zsh-completion

# powerlevel10k
ln -s $dotfiles_path/zsh/powerlevel10k ~/.oh-my-zsh/custom/themes

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# link files to parent
stow . -v
