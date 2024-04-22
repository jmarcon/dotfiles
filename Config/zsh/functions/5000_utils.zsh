#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow} Loading Functions [5000] - Utils'
fi

function mkd() {
    mkdir -p "$@" && cd "$_";
}

function gi() {
    curl -L -s https://www.gitignore.io/api/$@ ;
}
