#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5900] - AI' 'yellow'

if verify_commands gemini; then
	function gfuck() {
		local CMD_TO_RUN=$(__cmd "$@")
		[ -z "$CMD_TO_RUN" ] && {
			print_error "No command found to run."
			return 1
		}
		echo "Running the command: $CMD_TO_RUN"
		local CMD_OUTPUT=$(eval "$CMD_TO_RUN" 2>&1)
		local AI_PROMPT="Eu rodei o commando '$CMD_TO_RUN' e aqui está o resultado:\n$CMD_OUTPUT\nMe dê uma análise detalhada do que aconteceu, possíveis erros, sugestões de melhorias e próximos passos."

		if verify_commands glow; then 
			gemini -m "gemini-3-flash-preview" -p "$AI_PROMPT" | glow -s dark
		else
			gemini -m "gemini-3-flash-preview" -p "$AI_PROMPT"
		fi
	}
fi

if verify_commands codex; then
	function gptfuck() {
		local CMD_TO_RUN=$(__cmd "$@")
		[ -z "$CMD_TO_RUN" ] && {
			print_error "No command found to run."
			return 1
		}
		echo "Running the command: $CMD_TO_RUN"
		local CMD_OUTPUT=$(eval "$CMD_TO_RUN" 2>&1)
		local AI_PROMPT="Eu rodei o commando '$CMD_TO_RUN' e aqui está o resultado:\n$CMD_OUTPUT\nMe dê uma análise detalhada do que aconteceu, possíveis erros, sugestões de melhorias e próximos passos."


		if verify_commands glow; then 
			codex --skip-git-repo-check exec "$AI_PROMPT" | glow -s dark
		else
			codex --skip-git-repo-check exec "$AI_PROMPT"
		fi
		
	}
fi

if verify_commands claude; then
	function cfuck() {
		local CMD_TO_RUN=$(__cmd "$@")
		[ -z "$CMD_TO_RUN" ] && {
			print_error "No command found to run."
			return 1
		}
		echo "Running the command: $CMD_TO_RUN"
		local CMD_OUTPUT=$(eval "$CMD_TO_RUN" 2>&1)
		local AI_PROMPT="Eu rodei o commando '$CMD_TO_RUN' e aqui está o resultado:\n$CMD_OUTPUT\nMe dê uma análise detalhada do que aconteceu, possíveis erros, sugestões de melhorias e próximos passos."

		if verify_commands glow; then 
			claude --model 'claude-haiku-4-5' -p "$AI_PROMPT" | glow -s dark
		else
			claude --model "claude-haiku-4-5" -p "$AI_PROMPT" 
		fi
	}
fi

