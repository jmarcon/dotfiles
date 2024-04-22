#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow}  ♾️️ Loading Aliases [4200] - Folder Navigation'
fi

# If zoxide is installed, use it
if command -v z &> /dev/null; then
  alias cd="z"
fi

alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"

