#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
  echo ". Path file"
fi

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
  if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo ". Path local file"
  fi

  source ~/.dotfiles/.path.local.zsh
fi
