#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4999] - Others' 'yellow'

if command -v btop >/dev/null 2>&1; then
alias top="btop"
alias htop="btop"
alias bpytop="btop"
fi 

if command -v bat >/dev/null 2>&1; then
alias cat="bat --paging never --theme DarkNeon --tabs 2"
fi 

if command -v batcat >/dev/null 2>&1; then
alias cat="batcat --paging never --theme Dracula --tabs 2"
fi 

if command -v nvim >/dev/null 2>&1; then
alias vim="nvim"
fi
