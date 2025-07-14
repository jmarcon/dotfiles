#!/bin/zsh
print_debug '  ♾️️ Initializing [2500] - Python' 'yellow'

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi
