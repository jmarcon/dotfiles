#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow}  ♾️️ Loading Aliases [4800] - Homebrew'
fi

if command -v brew >/dev/null 2>&1; then
alias brewup="brew update && brew upgrade && brew cleanup && brew doctor"
fi
