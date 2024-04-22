#!/bin/zsh

if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Path variable [KREW]..."
fi

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"