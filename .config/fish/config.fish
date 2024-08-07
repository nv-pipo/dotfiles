
# Paths
# ~/bin
fish_add_path $HOME/bin
# Homebrew
fish_add_path $HOME/homebrew/bin
fish_add_path $HOME/homebrew/sbin
# VSCODE
fish_add_path $HOME"/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
# ~/conda
fish_add_path $HOME/miniforge3/bin/

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# fzf
# fzf --fish | source # DISABLE fzf's fish integration in favour of #PatrickF1/fzf.fish
fzf_configure_bindings --directory=\es
set -x FZF_DEFAULT_OPTS "--height 40% --ansi --border --prompt ' ' --layout reverse"
set -x FZF_DEFAULT_COMMAND "fd --type f --hidden --follow"

# Aliasses
alias exa='eza'
# alias cat='bat'
alias ls='eza --color=always --long --icons=always --no-user --no-filesize --no-time --no-permissions'
alias sshv="ssh -l velasquez"
alias ssha="ssh -l administrator"
alias sd="say done"
alias l="eza --color=always --long --git --icons=always --time-style=long-iso"
alias lt="eza --color=always --long --git --icons=always --time-style=long-iso --sort=time"
alias beep="echo -ne '\a'"
alias init_conda="eval conda \"shell.fish\" \"hook\" $argv | source"
# command not found for brew
if test -e ~/homebrew
    alias cnf="brew which-formula --explain "
end

# up directory Alt+Up
bind \e\[1\;3A upd

zoxide init --cmd cd fish | source
starship init fish | source
set -x STARSHIP_CONFIG ~/.config/starship/starship.toml

# Change editor to nvim
set -x EDITOR nvim
