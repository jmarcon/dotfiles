#!/bin/zsh
print_debug '  ♾️️ Initializing [2500] - Python' 'yellow'

verify_commands pyenv || return 1

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
