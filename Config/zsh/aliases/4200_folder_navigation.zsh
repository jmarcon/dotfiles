#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4200] - Folder Navigation' 'yellow'

# If zoxide is installed, use it
if verify_commands z; then
  alias cd="z"
fi

alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"
