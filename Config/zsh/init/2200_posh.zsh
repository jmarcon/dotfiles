#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow}  ♾️️ Initializing [2200] - Oh-My-Posh'
fi

if command -v oh-my-posh >/dev/null 2>&1; then
    if command -v brew >/dev/null 2>&1; then
        eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/iterm2.omp.json)"
    else
        if [ -n "${POSH_THEMES_PATH+1}" ]; then
            eval "$(oh-my-posh init zsh)"
            POSH_THEME="$POSH_THEMES_PATH/iterm2.omp.json"
        elif [ -d "/home/vscode/.oh-my-posh/themes" ]; then
            eval "$(oh-my-posh init zsh)"
            POSH_THEME='/home/vscode/.oh-my-posh/themes/iterm2.omp.json'
        fi
    fi
fi