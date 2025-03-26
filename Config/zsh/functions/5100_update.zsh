#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5100] - Update' 'yellow'

## Depends on init/tools.zsh that sets CURRENT_OS
function update() {
    if [[ "$CURRENT_OS" == "mac" ]]; then
        
    fi

    if [[ "$CURRENT_OS" == "linux" ]]; then
        sudo apt update && sudo apt upgrade
        if command -v snap >/dev/null 2>&1; then
            sudo snap refresh --list
        fi

        if command -v flatpak >/dev/null 2>&1; then
            flatpak update
        fi
    fi

    if command -v brew >/dev/null 2>&1; then
        local brew="brew update; brew upgrade; brew upgrade --cask --greedy; brew cleanup"
        sh -c $brew;
    fi
}
