#!/bin/zsh

print_debug '  ♾️️ Setting PATH [3200] - Plugins' 'yellow'

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
