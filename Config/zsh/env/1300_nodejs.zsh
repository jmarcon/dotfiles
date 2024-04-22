#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Environment Variables [NodeJS]..."
fi
export NVM_DIR="$HOME/.nvm"
