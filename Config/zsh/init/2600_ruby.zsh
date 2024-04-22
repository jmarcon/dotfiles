#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow} Initializing [2600] - Ruby'
fi

if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi