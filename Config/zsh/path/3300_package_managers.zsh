

# Yarn global packages
if verify_commands yarn; then
    export PATH="$(yarn global bin):$PATH"
fi

# NPM global packages
if verify_commands npm; then
    export PATH="$(npm prefix -g)/bin:$PATH"
fi
