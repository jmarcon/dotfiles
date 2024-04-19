#!/bin/zsh
# Lines configured by zsh-newuser-install
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


