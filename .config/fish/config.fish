
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

# Aliases
alias exa='eza'
# alias cat='bat'
alias ls='eza --color=always --long --icons=always --no-user --no-filesize --no-time --no-permissions'
alias sshv="ssh -l velasquez"
alias ssha="ssh -l administrator"
alias sd="say done"
alias l="eza --color=always --long --git --icons=always --time-style=long-iso"
alias lt="eza --color=always --long --git --icons=always --time-style=long-iso --sort=time"
alias beep="echo -ne '\a'"
alias start_reverse_shell_server="az container start --resource-group rg-connectivity --name aci-connectivity"
if test -e ~/homebrew
    alias cnf="brew which-formula --explain "
end

# up directory Alt+Up
bind \e\[1\;3A upd
bind tab complete-and-search

# CONDA/MAMBA
if test -d "$HOME/miniforge3"
    # !! Contents within this block are managed by 'conda init' !!
    if test -f $HOME/miniforge3/bin/conda
        eval $HOME/miniforge3/bin/conda "shell.fish" "hook" $argv | source
    else
        if test -f "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
            . "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
        else
            set -x PATH "$HOME/miniforge3/bin" $PATH
        end
    end

    # !! Contents within this block are managed by 'conda init' !!
    if test -f $HOME/miniforge3/bin/conda
        eval $HOME/miniforge3/bin/conda "shell.fish" "hook" $argv | source
    else
        if test -f "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
            . "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
        else
            set -x PATH "$HOME/miniforge3/bin" $PATH
        end
    end

    if test -f "$HOME/miniforge3/etc/fish/conf.d/mamba.fish"
        source "$HOME/miniforge3/etc/fish/conf.d/mamba.fish"
    end
end

zoxide init --cmd cd fish | source
starship init fish | source
set -x STARSHIP_CONFIG ~/.config/starship/starship.toml

# Change editor to nvim
set -x EDITOR nvim
