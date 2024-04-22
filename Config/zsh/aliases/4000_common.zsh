#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [000 - Common]..."
fi

alias c="clear"

alias rm="rm -i"
alias cp="cp -iv"
alias mv="mv -iv"
alias quit=exit
alias reload="source ~/.zshrc"