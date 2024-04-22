#!/bin/zsh

if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow} Setting PATH [3000] - Common'
fi

export PATH="$HOME/.apps:$PATH"
export PATH="$HOME/.scripts:$PATH"
