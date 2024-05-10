#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow}  ♾️️ Initializing [2300] - Homebrew'
fi

if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
fi
