#!/bin/zsh

print_debug '  ♾️️ Setting PATH [3100] - Languages & Runtimes' 'yellow'

## Dotnet
if [ -d "$DOTNET_ROOT" ]; then
    add_in_path "$DOTNET_ROOT"
    add_in_path "$DOTNET_ROOT/tools"
fi

## Ruby
if [ -d "$HOME/.rbenv/bin" ]; then
    add_in_path "$HOME/.rbenv/bin"
fi

## Python | PyEnv
if [ -d "$PYENV_ROOT/bin" ]; then
    add_in_path "$PYENV_ROOT/bin"
fi

## Rust
if [ -d "$HOME/.cargo" ]; then
    add_in_path "$HOME/.cargo/bin"
fi

## Julia
if [ -d "$HOME/.apps/julia/bin" ]; then
    add_in_path "$HOME/.apps/julia/bin"
fi

## Golang
if [ -d "$HOME/.apps/go/bin" ]; then
    add_in_path "$HOME/.apps/go/bin"
fi

if [ -d "$HOME/go/bin" ]; then
    add_in_path "$HOME/go/bin"
fi
