#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4400] - Http' 'yellow'

if verify_commands curl; then
    alias myip="curl http://whatismyip.akamai.com/"
    alias dotnet_install="curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin "
fi
