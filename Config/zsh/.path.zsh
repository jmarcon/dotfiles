#!/bin/zsh
print_debug '=> 📁️ Updating PATH env [3000]' 'blue'

## Source the aliases
dir=$(dirname $(realpath $0))

## Aliases
## Get All files in the env folder
for zfile in "$dir/path/"*.zsh; do
  if ! source "$zfile"; then
    print_debug "Error sourcing $zfile, skipping..." 'red'
  fi
done

## Source a local file if it exists
if [ -f ~/.dotfiles/.path.local.zsh ]; then
  if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo ". Path local file"
  fi

  if ! source ~/.dotfiles/.path.local.zsh; then
    print_debug "Error sourcing local path, skipping..." 'red'
  fi
fi
