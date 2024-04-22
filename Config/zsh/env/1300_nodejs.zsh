#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow}  ♾️️ Loading Environment Variables [1300] - NodeJS'
fi
export NVM_DIR="$HOME/.nvm"
