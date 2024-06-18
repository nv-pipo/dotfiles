gm() {
    if [[ $# -ne 2 ]]; then
        echo "Do a git merge from one branch to another. Usage: gm <from> <to>"
        return 1
    fi
    echo "Doing git merge from $1 -> $2"
    # Save current branch
    current_branch=$(git branch --show-current)
    # stash everything
    git stash --include-untracked
    # Do the merge
    git checkout $2
    git merge $1
    # Push the changes
    git push
    # Go back to the original branch
    git checkout $current_branch
    # pop the stash
    git stash pop
}
