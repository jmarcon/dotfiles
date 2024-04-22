#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Init [Homebrew]..."
fi

eval "$(brew shellenv)"