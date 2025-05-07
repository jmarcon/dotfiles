#!/bin/zsh

print_debug '  ♾️️ Setting PATH [3100] - Languages & Runtimes' 'yellow'

## Dotnet
if [ -d "$DOTNET_ROOT" ]; then
    export PATH="$DOTNET_ROOT:$PATH"
    export PATH="$DOTNET_ROOT/tools:$PATH"
fi

## Ruby
if [ -d "$HOME/.rbenv/bin" ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
fi

## Python | PyEnv
if [ -d "$PYENV_ROOT/bin" ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

## Rust
if [ -d "$HOME/.cargo" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

## Julia
if [ -d "$HOME/.apps/julia/bin" ]; then
    export PATH="$HOME/.apps/julia/bin:$PATH"
fi

## Golang
if [ -d "$HOME/.apps/go/bin" ]; then
    export PATH="$HOME/.apps/go/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ]; then
    export PATH="$HOME/go/bin:$PATH"
fi
