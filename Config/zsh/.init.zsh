#!/bin/zsh
print_debug '=> 📁️ Initializing Shell [2000]' 'red'

## Source the aliases
dir=$(dirname $(realpath $0))

## Aliases
## Get All files in the env folder
for zfile in "$dir/init/"*.zsh; do
  source $zfile
done

## Source a local file if it exists
if [ -f ~/.dotfiles/.init.local.zsh ]; then
  if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo ". Init Local file"
  fi
  source ~/.dotfiles/.init.local.zsh
fi
