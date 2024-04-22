#!/bin/zsh

if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{red}=> 📁️  Loading Aliases [4000]'
fi
# ## Source the aliases
# dir=$(dirname $(realpath $0))

## Aliases
## Get All files in the aliases folder
for zfile in "$dir/aliases/"*.zsh;
do
  source $zfile
done

## Source a local file if it exists
if [ -f ~/.dotfiles/.aliases.local.zsh ]; then
  if [[ "$DEBUG_DOTFILES" == "true" ]]; then
      echo ". Aliases local file"
  fi
  source ~/.dotfiles/.aliases.local.zsh
fi
