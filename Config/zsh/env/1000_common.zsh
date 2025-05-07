#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow}  ♾️️ Loading Environment Variables [1000] - Common'
fi

# Homebrew (linux)
# If the file brew exists, then load the shellenv : correct path

if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Using my birth year, just because
export PORT=1982
export APP_ENV=local
export RUNNING_IN_CONTAINER=false
