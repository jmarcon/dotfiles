#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [500 - Python]..."
fi

if command -v python >/dev/null 2>&1; then
alias webserver="python -m SimpleHTTPServer 1982"
alias server="webserver"
fi