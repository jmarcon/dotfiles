#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5700] - Completions' 'yellow'

if verify_commands tilt; then
	print_debug '    ♾️️ Loading tilt completions' 'green'
    source <(tilt completion zsh)
fi

if verify_commands kubectl; then
	print_debug '    ♾️️ Loading kubectl completions' 'green'
    source <(kubectl completion zsh)
fi

if verify_commands helm; then
	print_debug '    ♾️️ Loading helm completions' 'green'
    source <(helm completion zsh)
fi

if verify_commands k9s; then
	print_debug '    ♾️️ Loading k9s completions' 'green'
    source <(k9s completion zsh)
fi

if verify_commands ruff; then
	print_debug '    ♾️️ Loading ruff completions' 'green'
    eval "$(ruff generate-shell-completion zsh)"
fi

if verify_commands uv; then
	print_debug '    ♾️️ Loading uv completions' 'green'
    eval "$(uv generate-shell-completion zsh)"
fi
