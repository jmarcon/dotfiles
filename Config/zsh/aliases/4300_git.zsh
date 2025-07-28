#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4300] - GIT' 'yellow'

verify_commands git || return 1

alias gs="git status"
alias gp="git pull"
alias gf="git fetch --all"
alias gw="git switch"
alias gc="git commit"

