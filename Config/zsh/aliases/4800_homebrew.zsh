#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [800 - Homebrew]..."
fi

if command -v brew >/dev/null 2>&1; then
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Set Aliases [801 - Brew]..."
fi
alias brewup="brew update && brew upgrade && brew cleanup && brew doctor"
fi
