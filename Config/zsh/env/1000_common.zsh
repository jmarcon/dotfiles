#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow} Loading Environment Variables [1000] - Common'
fi
# Using my birth year, just because
export PORT=1982
export APP_ENV=local
export RUNNING_IN_CONTAINER=false

