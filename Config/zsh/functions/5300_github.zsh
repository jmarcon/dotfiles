#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5300] - Github' 'yellow'

verify_commands copilot || return 1

if command -v copilot &> /dev/null || gh copilot -- --version &> /dev/null; then
    print_debug "      Loading ghcs and ghce functions" 'green'

	function ghcs() {
		# GitHub Copilot suggest wrapper for command suggestions
		copilot --model "claude-haiku-4.5" --allow-all-tools -p "Suggest a shell command to: $*"
	}

	function ghce() {
		# GitHub Copilot explain wrapper for command explanations
		local last_command=$(fc -ln -1)
		if [[ -n "$*" ]]; then
			copilot --model "claude-haiku-4.5" -p "Explain this command: $*"
		else
			copilot --model "claude-haiku-4.5" -p "Explain this command: $last_command"
		fi
	}

fi
