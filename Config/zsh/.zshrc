#!/bin/zsh
# Activate the debug mode
export DEBUG_DOTFILES="false"

# If the DEBUG_DOTFILES variable is set to true, then print the message
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
  echo "DEBUG_DOTFILES is enabled..."
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -e

zstyle :compinstall filename '$HOME/.zshrc'

# Homebrew (linux)
# If the file brew exists, then load the shellenv

if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

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
