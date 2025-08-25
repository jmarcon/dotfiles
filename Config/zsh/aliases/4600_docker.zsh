#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4600] - Cloud' 'yellow'

verify_commands docker || return 1

alias d="docker"
alias dps="docker ps -a"