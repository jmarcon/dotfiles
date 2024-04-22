#!/bin/zsh
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [Http]..."
fi

if command -v curl >/dev/null 2>&1; then
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    echo "Loading Aliases [CURL]..."
fi
alias myip="curl http://whatismyip.akamai.com/"
alias dotnet_install="curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin "
fi
