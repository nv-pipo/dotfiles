#!/bin/bash

# dependencies
brew install neofetch onefetch htop wget nvim ripgrep tmux lua exa zoxide

# vars
dotfiles_path=`pwd`

# configure
# oh-my-zsh
ln -s $dotfiles_path/zsh/oh-my-zsh ~/.oh-my-zsh
ln -s $dotfiles_path/zsh/.zshrc ~/.zshrc

# zsh-autosuggestions
ln -s $dotfiles_path/zsh/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins

# powerlevel10k
ln -s $dotfiles_path/zsh/powerlevel10k ~/.oh-my-zsh/custom/themes
ln -s $dotfiles_path/zsh/.p10k.zsh ~/.p10k.zsh

# tmux
ln -s $dotfiles_path/tmux/.tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# nvchad
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
ln -s $dotfiles_path/nvchad/custom ~/.config/nvim/lua

# fzf
$(brew --prefix)/opt/fzf/install
