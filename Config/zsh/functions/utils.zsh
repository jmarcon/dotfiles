#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Environment Variables [Utils]..."
fi

function mkd() {
    mkdir -p "$@" && cd "$_";
}

function gi() {
    curl -L -s https://www.gitignore.io/api/$@ ;
}
