#!/bin/zsh
export DEBUG_DOTFILES="false"
[ -f ~/.dotfiles/.global.functions.zsh ] && source ~/.dotfiles/.global.functions.zsh
[ -f ~/.dotfiles/.global.functions.local.zsh ] && source ~/.dotfiles/.global.functions.local.zsh

# If the DEBUG_DOTFILES variable is set to true, then print the message
print_debug "DEBUG_DOTFILES is enabled..." "orange"

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -e

zstyle :compinstall filename '$HOME/.zshrc'

## Source Init files
[ -f ~/.dotfiles/.env.zsh ] && source ~/.dotfiles/.env.zsh
[ -f ~/.dotfiles/.init.zsh ] && source ~/.dotfiles/.init.zsh
[ -f ~/.dotfiles/.path.zsh ] && source ~/.dotfiles/.path.zsh

# Homebrew completions
if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
autoload -Uz compinit
compinit

## Source Aliases and Functions
[ -f ~/.dotfiles/.aliases.zsh ] && source ~/.dotfiles/.aliases.zsh
[ -f ~/.dotfiles/.functions.zsh ] && source ~/.dotfiles/.functions.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# bun completions
[ -s "/Users/jm/.bun/_bun" ] && source "/Users/jm/.bun/_bun"

# bun

export BUN_INSTALL="$HOME/.bun"
add_in_path "$BUN_INSTALL/bin"
add_in_path "$HOME/.local/bin"

clean_path
