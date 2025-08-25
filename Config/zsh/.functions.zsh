#!/bin/zsh
print_debug '=> 📁️ Loading Functions [5000]' 'blue'

## Source the aliases
dir=$(dirname $(realpath $0))

## Aliases
## Get All files in the env folder
for zfile in "$dir/functions/"*.zsh; do
  if ! source "$zfile"; then
    print_debug "Error sourcing $zfile, skipping..." 'red'
  fi
done

## Source a local file if it exists
if [ -f ~/.dotfiles/.functions.local.zsh ]; then
  print_debug ' 📍 Loading Local Functions' 'blue'

  if ! source ~/.dotfiles/.functions.local.zsh; then
    print_debug "Error sourcing local functions, skipping..." 'red'
  fi
fi
