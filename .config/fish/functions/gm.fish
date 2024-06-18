function gm  --description "Do git merge from branches source -> dest"
    if test (count $argv) -ne 2
        echo "Usage: gm source dest"
        return 1
    end
    echo "Doing git merge from $argv[1] -> $argv[2]"
    # Save current branch
    set current_branch (git branch --show-current)
    # stash everything
    git stash --include-untracked
    # Do the merge
    git checkout $argv[2]
    git merge $argv[1]
    # Push the changes
    git push
    # Go back to the original branch
    git checkout $current_branch
    # pop the stash
    git stash pop
end
