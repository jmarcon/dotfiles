#!/bin/zsh

function update() {
    sudo apt update && sudo apt upgrade
    sudo snap refresh --list

    local brew="brew update; brew upgrade; brew cleanup"
    sh -c $brew;
}
