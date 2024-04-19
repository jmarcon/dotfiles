#!/bin/zsh

## Source the aliases
dir=$(dirname $(realpath $0))

## Aliases
## Get All files in the env folder
for zfile in "$dir/functions/"*.zsh; 
do
  source $zfile
done

## Source a local file if it exists
if [ -f ~/.dotfiles/.functions.local.zsh ]; then
  source ~/.dotfiles/.functions.local.zsh
fi
