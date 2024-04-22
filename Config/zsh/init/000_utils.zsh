#!/bin/zsh 
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Init [00_Utils]..."
fi

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

function show_title() {
  local title="$1"
  local title_length=${#title}
  local title_line=$(printf "%${title_length}s" | tr ' ' '=')
  print -P "%F{red}\n$title\n$title_line\n"
}