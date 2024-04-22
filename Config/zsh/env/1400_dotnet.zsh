#!/bin/zsh 
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow} Loading Environment Variables [1400] - DOTNET'
fi
# Dotnet
export DOTNET_ROOT=$HOME/.dotnet