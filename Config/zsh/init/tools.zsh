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

# fzf
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi 

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
<<<<<<< HEAD

# thefuck
if command -v thefuck >/dev/null 2>&1; then 
  eval $(thefuck --alias)
  eval $(thefuck --alias fk)
fi
||||||| parent of 4ab5d67 (Add tools to nvim, udpate, os_detection, and a common path.)

=======
>>>>>>> 4ab5d67 (Add tools to nvim, udpate, os_detection, and a common path.)
