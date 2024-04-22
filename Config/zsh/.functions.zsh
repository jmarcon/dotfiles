#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
  echo ". Function file [5000]"
fi

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
  if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo ". Function Local file"
  fi
  source ~/.dotfiles/.functions.local.zsh
fi
