if command -v tilt >/dev/null 2>&1; then
    source <(tilt completion zsh)
fi

if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
fi

if command -v helm >/dev/null 2>&1; then
    source <(helm completion zsh)
fi

if command -v k9s >/dev/null 2>&1; then
    source <(k9s completion zsh)
fi

if command -v ruff >/dev/null 2>&1; then
    eval "$(ruff generate-shell-completion zsh)"
fi

if command -v uv >/dev/null 2>&1; then
    eval "$(uv generate-shell-completion zsh)"
fi
