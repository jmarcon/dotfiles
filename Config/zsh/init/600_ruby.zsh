#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Init  [Ruby]..."
fi

if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi