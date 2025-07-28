#!/bin/zsh
print_debug '  ♾️️ Loading Aliases [4900] - Artificial Intelligence CLIs' 'yellow'

alias claude="/Users/jm/.claude/local/claude"

if verify_commands npx; then
    # Artifitial Intelligence Cli
    ## Gemini
    alias gai="npx --yes https://github.com/google-gemini/gemini-cli"

    ## Rulesync (Sync rules in multiple AI. The rules must be edited in .rulesync/rules)
    alias rulesync="npx --yes rulesync@latest"
fi