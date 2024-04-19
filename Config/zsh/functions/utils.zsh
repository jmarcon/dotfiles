#!/bin/zsh

function mkd() {
    mkdir -p "$@" && cd "$_";
}

function gi() {
    curl -L -s https://www.gitignore.io/api/$@ ;
}
