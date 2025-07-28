#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5300] - Github' 'yellow'

verify_commands gh || return 1

if gh extension list | grep -q 'copilot'; then
    print_debug "      Loading ghcs and ghce functions" 'green'
	eval "$(gh copilot alias zsh)"
fi
