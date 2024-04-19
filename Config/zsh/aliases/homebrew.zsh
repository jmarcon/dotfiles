#!/bin/zsh

if command -v brew >/dev/null 2>&1; then
alias brewup="brew update && brew upgrade && brew cleanup && brew doctor"
fi
