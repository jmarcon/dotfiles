#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4100] - File Listing' 'yellow'

if verify_commands eza; then
	EZA_TREE_IGNORE=".fseventsd|.Spotlight-V100|.Trashes|__MACOSX|.DS_Store"
    # alias ls='eza --icons=always --color=always  --no-filesize --no-time --no-user --no-permissions --long'
    alias ls='eza --icons=always --color=always '
    alias ll='eza --icons=always --color=always  --long --all'
    alias la='eza --icons=always --color=always  --all'
    alias lc='eza --icons=always --color=always  --long'
    alias lh='eza --icons=always --color=always  --long --all -h'
    alias lg='eza --icons=always --color=always  --long --all --group-directories-first'
    alias lt='eza --icons=always --color=always  --tree --level=2 --group-directories-first --all --ignore-glob="${EZA_TREE_IGNORE}"'
    alias lt1='eza --icons=always --color=always  --tree --level=1 --group-directories-first --all  --ignore-glob="${EZA_TREE_IGNORE}"'
    alias lt2=lt
    alias lt3='eza --icons=always --color=always  --tree --level=3 --group-directories-first --all --ignore-glob="${EZA_TREE_IGNORE}"'
    alias lt4='eza --icons=always --color=always  --tree --level=4 --group-directories-first --all --ignore-glob="${EZA_TREE_IGNORE}"'
    alias l='eza --icons=always --color=always  --no-filesize --no-time --no-user --no-permissions --long --tree --level=1 --group-directories-first --all --ignore-glob="${EZA_TREE_IGNORE}"'
else
    alias ll="ls -lAh"
    alias la="ls -la"
    alias lc="ls -l"
    alias lh="ls -lah"
    alias lg="ls -lG"
fi
