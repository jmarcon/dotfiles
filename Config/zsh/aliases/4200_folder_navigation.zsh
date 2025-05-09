#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4200] - Folder Navigation' 'yellow'

# If zoxide is installed, use it
if command -v z &>/dev/null; then
  alias cd="z"
fi

alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"
