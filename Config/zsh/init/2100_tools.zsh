#!/bin/zsh

print_debug '  ♾️️ Initializing [2100] - Tools' 'yellow'

# fzf
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi 

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# thefuck
if command -v thefuck >/dev/null 2>&1; then 
  eval $(thefuck --alias)
  eval $(thefuck --alias fk)
fi
