#!/bin/zsh
print_debug '  ♾️️ Initializing [2600] - Ruby' 'yellow'

verify_commands rbenv || return 1

eval "$(rbenv init -)"
