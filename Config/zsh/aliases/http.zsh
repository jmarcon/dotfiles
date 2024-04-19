#!/bin/zsh

if command -v curl >/dev/null 2>&1; then
alias myip="curl http://whatismyip.akamai.com/"
alias dotnet_install="curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin "
fi
