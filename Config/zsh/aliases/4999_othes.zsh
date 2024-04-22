#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow}  ♾️️ Loading Aliases [4999] - Others'
fi

if command -v btop >/dev/null 2>&1; then
alias top="btop"
alias htop="btop"
alias bpytop="btop"
fi 

if command -v bat >/dev/null 2>&1; then
# alias cat="bat --paging never --theme Dracula --tabs 2"
alias cat="bat --paging never --theme DarkNeon --tabs 2"
fi 

if command -v nvim >/dev/null 2>&1; then
alias vim="nvim"
fi