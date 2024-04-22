#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow}  ♾️️ Loading Aliases [4300] - GIT'
fi

# GIT
if command -v git >/dev/null 2>&1; then
alias gs="git status"
alias gp="git pull"
alias gf="git fetch --all"
alias gw="git switch"
alias gc="git commit"
fi
