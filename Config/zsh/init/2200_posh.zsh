#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow}  ♾️️ Initializing [2200] - Oh-My-Posh'
fi

if command -v oh-my-posh >/dev/null 2>&1; then
    if command -v brew >/dev/null 2>&1; then
        eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/jandedobbeleer.omp.json)"
    else
        if [ -n "${POSH_THEMES_PATH+1}" ]; then
            eval "$(oh-my-posh init zsh --config '$POSH_THEMES_PATH/jandedobbeleer.omp.json')"
        else
            eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json')"
        fi
    fi
fi 
