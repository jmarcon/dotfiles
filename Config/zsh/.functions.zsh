#!/bin/zsh
print_debug '=> 📁️ Loading Functions [5000]' 'red'

## Source the aliases
dir=$(dirname $(realpath $0))

## Aliases
## Get All files in the env folder
for zfile in "$dir/functions/"*.zsh; do
  source $zfile
done

## Source a local file if it exists
if [ -f ~/.dotfiles/.functions.local.zsh ]; then
  print_debug ' 📍 Loading Local Functions' 'yellow'
  source ~/.dotfiles/.functions.local.zsh
fi
