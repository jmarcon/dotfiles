#!/bin/zsh
print_debug '  ♾️️ Initializing [2300] - Homebrew' 'yellow'

if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
fi
