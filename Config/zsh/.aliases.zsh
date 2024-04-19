#!/bin/zsh
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
  source ~/.dotfiles/.aliases.local.zsh
fi
