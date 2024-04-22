#!/bin/zsh

if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [Cloud]..."
fi


if command -v docker >/dev/null 2>&1; then
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [Docker]..."
fi
alias d="docker"
alias dps="docker ps -a"
fi

if command -v kubectl >/dev/null 2>&1; then
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [Kubectl]..."
fi
alias k="kubectl"
alias kgp="k get pods -A"
alias kgs="k get svc -A"
alias kgn="k get nodes -A"
fi
