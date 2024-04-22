#!/bin/zsh 
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Environment Variables [DOTNET]..."
fi
# Dotnet
export DOTNET_ROOT=$HOME/.dotnet