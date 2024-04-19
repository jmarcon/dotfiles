#!/bin/zsh

# Load the OS type sourcing the os.zsh file to export the CURRENT_OS variable
# If the os.zsh exists in the same dir of this script, it will be sourced in the install.zsh
path=$(realpath $0)
dir=$(dirname $path)
os_file="$dir/os.zsh"
if [ -f "$os_file" ]; then
  source $os_file
fi

# If in linux
if [ "$CURRENT_OS" = "linux" ]; then
    # If snap is installed
    if command -v snap >/dev/null 2>&1; then
        declare -a snaps=(
            "chatgpt-desktop"
            "gtk-common-themes"
            "snapd"
        )

        for snap in "${snaps[@]}"; do
            sudo snap install $snap
        done
    fi
fi