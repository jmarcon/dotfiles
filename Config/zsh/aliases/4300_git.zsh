#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [300 - GIT]..."
fi

# GIT
if command -v git >/dev/null 2>&1; then
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [GIT available]..."
fi
alias gs="git status"
alias gp="git pull"
alias gf="git fetch --all"
alias gw="git switch"
alias gc="git commit"
fi
