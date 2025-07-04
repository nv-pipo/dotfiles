# reference: https://www.youtube.com/watch?v=ud7YxC33Z3w
#
#

# Which characters on top of alphanumeric are considered to be part of one word 
WORDCHARS="_"

# paths
export PATH=${HOME}/bin:$PATH
export PATH=${HOME}/.local/bin:$PATH
export PATH=${HOME}/.docker/bin:$PATH
export PATH=${HOME}/homebrew/bin:${PATH}
export PATH=${HOME}/homebrew/sbin:${PATH}

# nixos packages
if [ -e ${HOME}/.nix-profile/etc/profile.d/nix.sh ]; then
  . ${HOME}/.nix-profile/etc/profile.d/nix.sh;
  export LOCALE_ARCHIVE="$(nix-env --installed --no-name --out-path --query glibc-locales)/lib/locale/locale-archive"
fi

# homebrew
if [[ -f "${HOME}/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(${HOME}/homebrew/bin/brew shellenv)"
fi

# ZINIT
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
# zinit snippet OMZP::git
# zinit snippet OMZP::python

if which docker &> /dev/null ; then
  zinit ice as"completion"
  zinit snippet OMZP::docker/completions/_docker
fi

# if '${HOME}/homebrew/share/zsh/site-functions' exists add each file for completion
if [[ -d "${HOME}/homebrew/share/zsh/site-functions" ]]; then
  for f in ${HOME}/homebrew/share/zsh/site-functions/*; do
    zinit ice as"completion"
    zinit snippet $f
  done
fi

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q


# Keybindings
bindkey -e
bindkey '^[f' forward-word # alt + f
bindkey '^E'  end-of-line  # ctrl + e
bindkey '^p'  history-search-backward
bindkey '^n'  history-search-forward
# ctrl+u to delete from cursor, not whole line
bindkey '^u'  backward-kill-line
# ALT+UP_KEY to go up a directory (upd)
bindkey ''  upd

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt histignorespace
setopt no_share_history
unsetopt share_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
# case insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# Use fzf-tab "popup" feature
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# add slash to '..' when 'tab' is pressed
zstyle ':completion:*' special-dirs true

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Add aliases
alias lg='lazygit'
alias ls='eza --color=always --long --icons=always --no-user --no-filesize --no-time --no-permissions'
# alias ssh='env TERM=alacritty ssh'
alias sshv="ssh -l velasquez"
alias ssha="ssh -l administrator"
alias sudo="env TERM=$TERM sudo"
alias sd="say done"
alias l="eza --color=always --long --git --icons=always --time-style=long-iso"
alias lt="eza --color=always --long --git --icons=always --time-style=long-iso --sort=time"
alias beep="print \"\a\""
alias start_reverse_shell_server="az container start --resource-group rg-connectivity --name aci-connectivity"

# Add custom functions
if [[ -d "${HOME}/.config/zsh/functions/" ]]; then
  for f in ${HOME}/.config/zsh/functions/*; do
    source $f
  done
fi

if [[ -d "${HOME}/miniforge3" ]]; then
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('$HOME/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
          . "$HOME/miniforge3/etc/profile.d/conda.sh"
      else
          export PATH="$HOME/miniforge3/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<
fi

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# set the default editor
export EDITOR=nvim
