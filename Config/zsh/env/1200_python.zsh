#!/bin/zsh 
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow}  ♾️️ Loading Environment Variables [1200] - Python'
fi
# Pyenv
export PYENV_ROOT="$HOME/.pyenv"

