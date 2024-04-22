#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow}  ♾️️ Loading Aliases [4500] - Python'
fi

if command -v python >/dev/null 2>&1; then
alias webserver="python -m SimpleHTTPServer 1982"
alias server="webserver"
fi