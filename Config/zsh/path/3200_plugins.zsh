#!/bin/zsh

print_debug '  ♾️️ Setting PATH [3200] - Plugins' 'yellow'

add_in_path "${KREW_ROOT:-$HOME/.krew}/bin"
# export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
