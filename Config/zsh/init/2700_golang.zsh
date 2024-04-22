#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Init [GO Lang]..."
fi

if [ -d "$HOME/.cargo" ]; then
  . "$HOME/.cargo/env"
fi