#!/bin/zsh

# What OS is this?
# OS detection
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export CURRENT_OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export CURRENT_OS="mac"
elif [[ "$OSTYPE" == "cygwin" ]]; then
    export CURRENT_OS="windows"
elif [[ "$OSTYPE" == "msys" ]]; then
    export CURRENT_OS="windows"
elif [[ "$OSTYPE" == "win32" ]]; then
    export CURRENT_OS="windows"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
    export CURRENT_OS="freebsd"
else
    export CURRENT_OS="unknown"
    echo "Unknown OS: $OSTYPE"
fi