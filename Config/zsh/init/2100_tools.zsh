#!/bin/zsh

print_debug '  ♾️️ Initializing [2100] - Tools' 'yellow'

# fzf
if verify_commands fzf; then
  eval "$(fzf --zsh)" || print_debug "Failed to initialize fzf" "red"
fi

# zoxide
if verify_commands zoxide; then
  eval "$(zoxide init zsh)" || print_debug "Failed to initialize zoxide" "red"
fi

# thefuck
if verify_commands thefuck; then
  eval $(thefuck --alias) || print_debug "Failed to initialize thefuck" "red"
  eval $(thefuck --alias fk) || print_debug "Failed to initialize thefuck" "red"
fi
