send_terminfo() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: send_terminfo SERVER"
        return 1
    fi
    set -x
    infocmp -x | ssh $1 -- tic -x -
    set +x
}
