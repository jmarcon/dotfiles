#!/bin/zsh

if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [600 - Cloud]..."
fi

if command -v docker >/dev/null 2>&1; then
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Set Aliases [601 - Docker]..."
fi
alias d="docker"
alias dps="docker ps -a"
fi

if command -v kubectl >/dev/null 2>&1; then
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Set Aliases [602 - Kubectl]..."
fi
alias k="kubectl"
alias kgp="k get pods -A"
alias kgs="k get svc -A"
alias kgn="k get nodes -A"
fi
