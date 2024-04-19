#!/bin/zsh

if command -v eza >/dev/null 2>&1; then
alias ls='eza --icons=always --color=always --git-ignore --git --no-filesize --no-time --no-user --no-permissions --long'

fi

alias ll="ls -lAh"
alias la="ls -la"
alias lc="ls -l"
alias lh="ls -lah"
alias lg="ls -lG"