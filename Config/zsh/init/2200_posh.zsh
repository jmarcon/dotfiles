#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Init  [OhMyPosh]..."
fi

if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/jandedobbeleer.omp.json)"
fi 
