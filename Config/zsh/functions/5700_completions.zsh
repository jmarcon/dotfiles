if verify_commands tilt; then
    source <(tilt completion zsh)
fi

if verify_commands kubectl; then
    source <(kubectl completion zsh)
fi

if verify_commands helm; then
    source <(helm completion zsh)
fi

if verify_commands k9s; then
    source <(k9s completion zsh)
fi

if verify_commands ruff; then
    eval "$(ruff generate-shell-completion zsh)"
fi

if verify_commands uv; then
    eval "$(uv generate-shell-completion zsh)"
fi
