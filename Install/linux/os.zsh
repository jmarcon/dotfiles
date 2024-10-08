#!/usr/bin/zsh

# What OS is this?
# OS detection
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export CURRENT_OS="linux"
    return
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    export CURRENT_OS="mac"
    return
fi

if [[ "$OSTYPE" == "cygwin" ]]; then
    export CURRENT_OS="windows"
    return
fi

if [[ "$OSTYPE" == "msys" ]]; then
    export CURRENT_OS="windows"
    return
fi

if [[ "$OSTYPE" == "win32" ]]; then
    export CURRENT_OS="windows"
    return
fi

if [[ "$OSTYPE" == "freebsd"* ]]; then
    export CURRENT_OS="freebsd"
    return
fi

export CURRENT_OS="unknown"
echo "Unknown OS: $OSTYPE"
