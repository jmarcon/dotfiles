#!/bin/zsh
print_debug '  ♾️️ Initializing [2200] - Oh-My-Posh' 'yellow'

verify_commands oh-my-posh || return 1

if verify_commands brew; then
    eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/atomic.omp.json)"

    if [[ "$DEBUG_DOTFILES" == "true" ]]; then
        print -P '%F{magenta}  🍺 Using brew to get the oh-my-posh theme'
    fi
    eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/iterm2.omp.json)"
else
    if [ -n "${POSH_THEMES_PATH+1}" ]; then
        if [[ "$DEBUG_DOTFILES" == "true" ]]; then
            print -P '%F{magenta}  Using the $POSH_THEMES_PATH to get the oh-my-posh theme'
        fi
        eval "$(oh-my-posh init zsh)"
        POSH_THEME="$POSH_THEMES_PATH/atomic.omp.json"
    elif [ -d "/home/vscode/.oh-my-posh/themes" ]; then
        if [[ "$DEBUG_DOTFILES" == "true" ]]; then
            print -P '%F{magenta}  Force to use the /home/vscode/.oh-my-posh/themes to get the oh-my-posh them'
        fi
        eval "$(oh-my-posh init zsh)"
        POSH_THEME='/home/vscode/.oh-my-posh/themes/atomic.omp.json'
    else
        if [[ "$DEBUG_DOTFILES" == "true" ]]; then
            print -P '%F{magenta}  No oh-my-posh theme found'
        fi
    fi
fi
