#!/bin/zsh
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
  source ~/.dotfiles/.env.local.zsh
fi
