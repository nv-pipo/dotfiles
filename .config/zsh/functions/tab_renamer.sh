tab_name_update() {
    case $TERM in xterm*)
        precmd () {print -Pn "\e]2;%~\a"}
        ;;
    esac
}

tab_name_update
chpwd_functions+=(tab_name_update)
