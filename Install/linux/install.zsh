#!/bin/zsh

# If the os.zsh exists in the same dir of this script, it will be sourced in the install.zsh
dir=$(dirname $(realpath $0))
os_file="$dir/os.zsh"
if [ -f "$os_file" ]; then
	source $os_file
fi

# Is it windows?
if [ "$CURRENT_OS" = "windows" ]; then
	Write-Output "Windows doesn't support zsh."
fi

# Is it macos?
if [ "$CURRENT_OS" = "macos" ]; then
	## Homebrew
	brew_file="$dir/homebrew.zsh"
	if [ -f "$brew_file" ]; then
		source $brew_file
	fi

	## Git repos
	git_repos_file="$dir/git_repos.zsh"
	if [ -f "$git_repos_file" ]; then
		source $git_repos_file
	fi
fi

# Is it linux?
if [ "$CURRENT_OS" = "linux" ]; then
	## Apt
	apt_file="$dir/apt.zsh"
	if [ -f "$apt_file" ]; then
		source $apt_file
	fi

	## Snap
	snap_file="$dir/snap.zsh"
	if [ -f "$snap_file" ]; then
		source $snap_file
	fi

	## Homebrew
	brew_file="$dir/homebrew.zsh"
	if [ -f "$brew_file" ]; then
		source $brew_file
	fi

	## Git repos
	git_repos_file="$dir/git_repos.zsh"
	if [ -f "$git_repos_file" ]; then
		source $git_repos_file
	fi
fi
