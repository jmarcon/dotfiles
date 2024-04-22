#!/bin/zsh

if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Path variable [Common]..."
fi

export PATH="$HOME/.apps:$PATH"
export PATH="$HOME/.scripts:$PATH"
