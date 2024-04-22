#!/bin/zsh

if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow} Setting PATH [3200] - Plugins'
fi

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"