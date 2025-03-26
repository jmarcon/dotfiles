#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4500] - Python' 'yellow'

if command -v python >/dev/null 2>&1; then
alias webserver="python -m SimpleHTTPServer 1982"
alias server="webserver"
fi