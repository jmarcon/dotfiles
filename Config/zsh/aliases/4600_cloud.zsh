#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4600] - Cloud' 'yellow'

if command -v docker >/dev/null 2>&1; then
alias d="docker"
alias dps="docker ps -a"
fi

if command -v kubectl >/dev/null 2>&1; then
alias k="kubectl"
alias kgp="k get pods -A"
alias kgs="k get svc -A"
alias kgn="k get nodes -A"
fi
