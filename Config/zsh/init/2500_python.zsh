#!/bin/zsh
print_debug '  ♾️️ Initializing [2500] - Python' 'yellow'

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

if command -v ruff >/dev/null 2>&1; then 
  eval "$(ruff generate-shell-completion zsh)"
fi

if command -v uv >/dev/null 2>&1; then 
  eval "$(uv generate-shell-completion zsh)"
fi