#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow} Initializing [2300] - Homebrew'
fi

eval "$(brew shellenv)"