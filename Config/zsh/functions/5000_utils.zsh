#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5000] - Utils' 'yellow'

function mkd() {
    mkdir -p "$@" && cd "$_"
}

function gi() {
    curl -L -s https://www.gitignore.io/api/$@
}
