export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# If bat is available, use it for previews
if command -v bat >/dev/null 2>&1; then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
else
    export FZF_CTRL_T_OPTS="--preview 'cat {}'"
fi

# If eza is available, use it for previews
if command -v eza >/dev/null 2>&1; then
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
else 
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
fi
