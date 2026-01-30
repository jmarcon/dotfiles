#!/bin/zsh
print_debug '=> 📁️  Loading Aliases [4000]' 'blue'

# ## Source the aliases
# if not $dir defined, define it
dir=$(dirname "$(realpath $0)")

## Aliases
## Get All files in the aliases folder
for zfile in "$dir/aliases/"*.zsh; do
	print_debug "  ➡️  Sourcing alias file: $zfile" 'green'
	if ! source "$zfile"; then
		print_debug "Error sourcing $zfile, skipping..." 'red'
	fi
done

## Source a local file if it exists
if [ -f ~/.dotfiles/.aliases.local.zsh ]; then
	if [[ "$DEBUG_DOTFILES" == "true" ]]; then
		echo ". Aliases local file"
	fi
	if ! source ~/.dotfiles/.aliases.local.zsh; then
		print_debug "Error sourcing local aliases, skipping..." 'red'
	fi
fi
