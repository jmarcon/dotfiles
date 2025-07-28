#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4999] - Others' 'yellow'

if verify_commands btop; then
    alias top="btop"
    alias htop="btop"
    alias bpytop="btop"
fi

if verify_commands bat; then
    alias cat="bat --paging never --theme DarkNeon --tabs 2"
fi

if verify_commands batcat; then
    alias cat="batcat --paging never --theme Dracula --tabs 2"
fi

if verify_commands nvim; then
    alias vim="nvim"
fi