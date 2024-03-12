# If you come from bash you might have to change your $PATH.

export PATH=${HOME}/bin:$PATH
export PATH=${HOME}/homebrew/bin:${PATH}
export PATH=${HOME}/homebrew/sbin:${PATH}
export PATH="${HOME}/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
# export PATH=${HOME}/.dotnet:$PATH
export PATH="${PATH}:${HOME}/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
# LATEX
export PATH=${HOME}/Applications/texlive/2023basic/bin/universal-darwin/:${PATH} 
# export JAVA_HOME=/Users/pichurri/homebrew/Cellar/openjdk/15.0.1/libexec/openjdk.jdk/Contents/Home/

# completion fix (broken in apple silicon due to move from /usr/local to /opt/homebrew)
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git kubectl docker pip zsh-syntax-highlighting)
plugins=(
    git
    kubectl
    docker
    conda-zsh-completion
    pip
    python
)
# plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias sshv="ssh -l velasquez"
alias ssha="ssh -l administrator"
alias sd="say done"
alias ltr="ls -lhtr"
alias beep="print \"\a\""

############### MY oh my zsh SETTINGS ###############
# ctrl+u to delete from cursor, not whole line
bindkey \^U backward-kill-line

# DON'T share command history data
setopt no_share_history

# Remove pipenv autoload hook
add-zsh-hook -d chpwd _togglePipenvShell
############### MY oh my zsh SETTINGS ###############

############### PYENV ###############
# export PATH="/Users/pichurri/homebrew/opt/llvm@11/bin:$PATH"
# export PATH="${HOME}/homebrew/opt/openssl@1.1/bin:$PATH"
# export BLAS=$(brew --prefix openblas)/lib/libblas.dylib
# # For compilers to find zlib/bzip you may need to set:
# for l in xz zlib bzip2 openblas; do
#   export LDFLAGS="${LDFLAGS} -L$(brew --prefix $l)/lib"
#   export CPPFLAGS="${CPPFLAGS} -I$(brew --prefix $l)/include"
#   export FFLAGS="${FFLAGS} -I$(brew --prefix $l)/include"

#   # For pkg-config to find zlib you may need to set:
#   export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} $(brew --prefix $l)/lib/pkgconfig"
# done

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

############### MANUAL ACTIVATIONS ###############
source /Users/pichurri/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
############### MANUAL ACTIVATIONS ###############

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
# <<< conda initialize <<<

# If it doesn't exist init:
# conda create -n py3_12-shell python=3.12
conda activate py3_12-shell

# alias for printing csv from shell using python
dump_csv() { python -c "import pandas as pd ; print(pd.read_csv('${1}'))"}

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# default text editor to MICRO
export EDITOR=micro
