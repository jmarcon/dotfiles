#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4500] - Python' 'yellow'

verify_commands python || return 1

alias webserver="python -m SimpleHTTPServer 1982"
alias server="webserver"
