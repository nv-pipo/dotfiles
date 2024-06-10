if status is-interactive
    # Commands to run in interactive sessions can go here
end
starship init fish | source
fzf --fish | source

alias cat='bat'
alias ls='eza --color=always --long --icons=always --no-user --no-filesize --no-time --no-permissions'
alias sshv="ssh -l velasquez"
alias ssha="ssh -l administrator"
alias sd="say done"
alias l="eza --color=always --long --git --icons=always --time-style=long-iso"
alias lt="eza --color=always --long --git --icons=always --time-style=long-iso --sort=time"
alias beep="print \"\a\""

# >>> conda initialize >>>
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
# <<< conda initialize <<<
conda activate py3_12-shell
