#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [Homebrew]..."
fi

if command -v brew >/dev/null 2>&1; then
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [Brew Available]..."
fi
alias brewup="brew update && brew upgrade && brew cleanup && brew doctor"
fi
