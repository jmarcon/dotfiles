#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow} Loading Aliases [4100] - File Listing'
fi

if command -v eza >/dev/null 2>&1; then
# alias ls='eza --icons=always --color=always --git-ignore --git --no-filesize --no-time --no-user --no-permissions --long'
    alias ls='eza --icons=always --color=always --git-ignore --git'
    alias ll='eza --icons=always --color=always --git-ignore --git --long --all'
    alias la='eza --icons=always --color=always --git-ignore --git --all'
    alias lc='eza --icons=always --color=always --git-ignore --git --long'
    alias lh='eza --icons=always --color=always --git-ignore --git --long --all -h'
    alias lg='eza --icons=always --color=always --git-ignore --git --long --all --group-directories-first'
    alias  l='eza --icons=always --color=always --git-ignore --git --no-filesize --no-time --no-user --no-permissions --long --tree --level=1 --group-directories-first --all'
else
    alias ll="ls -lAh"
    alias la="ls -la"
    alias lc="ls -l"
    alias lh="ls -lah"
    alias lg="ls -lG"
fi