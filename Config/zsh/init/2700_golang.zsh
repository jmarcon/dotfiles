#!/bin/zsh
print_debug '  ♾️️ Initializing [2700] - GO Lang' 'yellow'

if [ -d "$HOME/.cargo" ]; then
  . "$HOME/.cargo/env"
fi