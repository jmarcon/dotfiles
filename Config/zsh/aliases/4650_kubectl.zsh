#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4600] - Cloud' 'yellow'

verify_commands kubectl || return 1

alias k="kubectl"
alias kgp="k get pods -A"
alias kgs="k get svc -A"
alias kgn="k get nodes -A"

