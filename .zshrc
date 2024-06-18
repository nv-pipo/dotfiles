# reference: https://www.youtube.com/watch?v=ud7YxC33Z3w
#
#

# Which characters on top of alphanumeric are considered to be part of one word 
WORDCHARS="?_"

# paths
export PATH=${HOME}/bin:$PATH
export PATH=${HOME}/homebrew/bin:${PATH}
export PATH=${HOME}/homebrew/sbin:${PATH}
export PATH="${HOME}/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
# export PATH=${HOME}/.dotnet:$PATH
export PATH="${PATH}:${HOME}/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# ZINIT
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load fzf from ~/.fzf if available
if [[ -d "${HOME}/.fzf/bin" && ! "$PATH" == *${HOME}/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}${HOME}/.fzf/bin"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

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

# if '/opt/homebrew/share/zsh/site-functions' exists add each file for completion
if [[ -d "/opt/homebrew/share/zsh/site-functions" ]]; then
  for f in /opt/homebrew/share/zsh/site-functions/*; do
    zinit ice as"completion"
    zinit snippet $f
  done
fi

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# ctrl+u to delete from cursor, not whole line
bindkey '^u' backward-kill-line

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

# Example aliases
alias cat='bat'
alias ls='eza --color=always --long --icons=always --no-user --no-filesize --no-time --no-permissions'
alias sshv="ssh -l velasquez"
alias ssha="ssh -l administrator"
alias sd="say done"
alias l="eza --color=always --long --git --icons=always --time-style=long-iso"
alias lt="eza --color=always --long --git --icons=always --time-style=long-iso --sort=time"
alias beep="print \"\a\""

if [[ -f "/Users/pichurri/miniforge3/bin/conda" ]] then
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('/Users/pichurri/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/Users/pichurri/miniforge3/etc/profile.d/conda.sh" ]; then
          . "/Users/pichurri/miniforge3/etc/profile.d/conda.sh"
      else
          export PATH="/Users/pichurri/miniforge3/bin:$PATH"
      fi
  fi
  unset __conda_setup

  if [ -f "/Users/pichurri/miniforge3/etc/profile.d/mamba.sh" ]; then
      . "/Users/pichurri/miniforge3/etc/profile.d/mamba.sh"
  fi
  # <<< conda initialize <<<
  conda activate shell
fi

