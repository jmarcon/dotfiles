#!/bin/zsh

## Source the aliases
dir=$(dirname $(realpath $0))

## Aliases
## Get All files in the env folder
for zfile in "$dir/path/"*.zsh; 
do
  source $zfile
done
## Source a local file if it exists
if [ -f ~/.dotfiles/.path.local.zsh ]; then
  source ~/.dotfiles/.path.local.zsh
fi
