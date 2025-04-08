#!/bin/zsh

print_debug '  ♾️️ Initializing [2100] - Tools' 'yellow'

# fzf
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)" || print_debug "Failed to initialize fzf" "red"
fi 

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)" || print_debug "Failed to initialize zoxide" "red"
fi

# thefuck
if command -v thefuck >/dev/null 2>&1; then 
  eval $(thefuck --alias) || print_debug "Failed to initialize thefuck" "red"
  eval $(thefuck --alias fk) || print_debug "Failed to initialize thefuck" "red"
fi
