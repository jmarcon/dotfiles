#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow}  ♾️️ Initializing [2700] - GO Lang'
fi

if [ -d "$HOME/.cargo" ]; then
  . "$HOME/.cargo/env"
fi