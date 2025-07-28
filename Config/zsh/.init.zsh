#!/bin/zsh
print_debug '=> 📁️ Initializing Shell [2000]' 'blue'

## Source the aliases
dir=$(dirname $(realpath $0))

## Aliases
## Get All files in the env folder
for zfile in "$dir/init/"*.zsh; do
  if ! source "$zfile"; then
    print_debug "Error sourcing $zfile, skipping..." 'red'
  fi
done

## Source a local file if it exists
if [ -f ~/.dotfiles/.init.local.zsh ]; then
  print_debug ' 📍 Loading Local Init' 'yellow'

  if ! source ~/.dotfiles/.init.local.zsh; then
    print_debug "Error sourcing local init, skipping..." 'red'
  fi
fi
