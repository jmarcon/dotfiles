#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5000] - Utils' 'yellow'

function mkd() {
    mkdir -p "$@" && cd "$_"
}

function gi() {
    curl -L -s https://www.gitignore.io/api/$@
}

function print_path() {
    echo $PATH | tr ':' '\n' | nl
}

function print_path_sorted() {
    echo $PATH | tr ':' '\n' | sort | nl
}
