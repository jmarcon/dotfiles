#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5000] - Utils' 'yellow'

function mkd() {
    mkdir -p "$@" && cd "$_"
}

function gi() {
    curl -L -s https://www.gitignore.io/api/$@
}

function print_path() {
    echo $PATH | tr ':' '\n' | nl
}

function print_path_sorted() {
    echo $PATH | tr ':' '\n' | sort | nl
}

function IsWindows() {
    if [[ "$CURRENT_OS" == "windows" ]]; then
        return 1
    else
        return 0
    fi
}

function IsLinux() {
    if [[ "$CURRENT_OS" == "linux" ]]; then
        return 1
    else
        return 0
    fi
}

function IsOsx() {
    if [[ "$CURRENT_OS" == "mac" ]]; then
        return 1
    else
        return 0
    fi
}

function __cmd() {
	if [ $# -gt 0 ]; then
		echo "$*"
	else
		fc -ln -1 -1 | sed 's/^[[:space:]]*//'
	fi
}