#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [Folder Navigation]..."
fi

# If zoxide is installed, use it
if command -v z &> /dev/null; then
  if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [Zoxide]..."
fi
  alias cd="z"
fi

alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"

