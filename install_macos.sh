#!/bin/bash

# dependencies
brew install neofetch onefetch htop wget nvim ripgrep tmux lua zoxide fzf stow

# vars
dotfiles_path=`pwd`

# configure
# oh-my-zsh
ln -s $dotfiles_path/zsh/oh-my-zsh ~/.oh-my-zsh
ln -s $dotfiles_path/zsh/.zshrc ~/.zshrc
git clone https://github.com/esc/conda-zsh-completion ~/.oh-my-zsh/custom/plugins/conda-zsh-completion

# powerlevel10k
ln -s $dotfiles_path/zsh/powerlevel10k ~/.oh-my-zsh/custom/themes
ln -s $dotfiles_path/zsh/.p10k.zsh ~/.p10k.zsh

# tmux
ln -s $dotfiles_path/tmux/.tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
