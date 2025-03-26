#!/bin/zsh
print_debug '  ♾️️ Initializing [2600] - Ruby' 'yellow'

if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi