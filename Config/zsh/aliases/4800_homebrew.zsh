#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4800] - Homebrew' 'yellow'

if verify_commands brew; then
    alias brewup="brew update && brew upgrade && brew cleanup && brew doctor"
fi
