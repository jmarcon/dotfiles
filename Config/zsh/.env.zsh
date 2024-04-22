#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
  print -P '%F{red}=> 📁️ Setting Environment Variables [1000]'
fi

## Source the aliases
dir=$(dirname $(realpath $0))

## Aliases
## Get All files in the env folder
for zfile in "$dir/env/"*.zsh; 
do
  source $zfile
done


## Source a local file if it exists
### Use this file to set your local environment variables
### include sensitive information like passwords, api keys, etc
### consider adding it to your .gitignore 
if [ -f ~/.dotfiles/.env.local.zsh ]; then
  if [[ "$DEBUG_DOTFILES" == "true" ]]; then
      echo ". Env local file"
  fi
  source ~/.dotfiles/.env.local.zsh
fi
