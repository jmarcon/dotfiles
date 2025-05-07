#!/bin/zsh
print_debug '  ♾️️ Initializing [2400] - NodeJS | NVM' 'yellow'

# If nvm is installed via homebrew
if command -v brew >/dev/null 2>&1; then
    [ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"                                       # This loads nvm
    [ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm" # This loads nvm bash_completion
fi

# NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
