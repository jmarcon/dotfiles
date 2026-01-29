#!/bin/zsh
print_debug '  ♾️️ Loading Environment Variables [1500] - Mise' 'yellow'

verify_commands mise || return 1


if verify_commands mise; then
	eval "$(mise activate zsh) " 
	eval "$(mise activate zsh --shims)"
fi