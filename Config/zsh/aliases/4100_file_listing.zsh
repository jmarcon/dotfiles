#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4100] - File Listing' 'yellow'

if command -v eza >/dev/null 2>&1; then
    # alias ls='eza --icons=always --color=always  --no-filesize --no-time --no-user --no-permissions --long'
    alias ls='eza --icons=always --color=always '
    alias ll='eza --icons=always --color=always  --long --all'
    alias la='eza --icons=always --color=always  --all'
    alias lc='eza --icons=always --color=always  --long'
    alias lh='eza --icons=always --color=always  --long --all -h'
    alias lg='eza --icons=always --color=always  --long --all --group-directories-first'
    alias lt='eza --icons=always --color=always  --tree --level=2 --group-directories-first --all'
    alias lt1='eza --icons=always --color=always  --tree --level=1 --group-directories-first --all'
    alias lt2=lt
    alias lt3='eza --icons=always --color=always  --tree --level=3 --group-directories-first --all'
    alias lt4='eza --icons=always --color=always  --tree --level=4 --group-directories-first --all'
    alias l='eza --icons=always --color=always  --no-filesize --no-time --no-user --no-permissions --long --tree --level=1 --group-directories-first --all'
else
    alias ll="ls -lAh"
    alias la="ls -la"
    alias lc="ls -l"
    alias lh="ls -lah"
    alias lg="ls -lG"
fi
