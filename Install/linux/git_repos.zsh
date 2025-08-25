#!/bin/zsh

# Try to clone a git repository ignoring the errors
if command -v git >/dev/null 2>&1; then
    if [ ! -d ~/.dotfiles/.fzf-git ]; then
        git clone https://github.com/junegunn/fzf-git.sh.git ~/.dotfiles/.fzf-git
    fi

    if [ ! -d ~/.git_repos/dotfiles ]; then
        git clone git@github.com:jmarcon/dotfiles.git ~/.git_repos/dotfiles
    fi

    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
else
    echo "git is not installed"
fi
