#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [Others]..."
fi

if command -v btop >/dev/null 2>&1; then
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [BTOP]..."
fi
alias top="btop"
alias htop="btop"
alias bpytop="btop"
fi 

if command -v bat >/dev/null 2>&1; then
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [BATCAT]..."
fi
# alias cat="bat --paging never --theme Dracula --tabs 2"
alias cat="bat --paging never --theme DarkNeon --tabs 2"
fi 

if command -v nvim >/dev/null 2>&1; then
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [NeoVIM]..."
fi
alias vim="nvim"
fi