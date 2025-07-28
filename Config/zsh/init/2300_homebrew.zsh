#!/bin/zsh
print_debug '  ♾️️ Initializing [2300] - Homebrew' 'yellow'

verify_commands brew || return 1

eval "$(brew shellenv)"

