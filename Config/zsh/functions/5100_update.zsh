#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow}  ♾️️ Loading Functions [5100] - Update'
fi

## Depends on init/tools.zsh that sets CURRENT_OS
function update() {
    if [[ "$CURRENT_OS" == "mac" ]]; then
        
    fi

    if [[ "$CURRENT_OS" == "linux" ]]; then
        sudo apt update && sudo apt upgrade
        sudo snap refresh --list
    fi

    local brew="brew update; brew upgrade; brew cleanup"
    sh -c $brew;
}
