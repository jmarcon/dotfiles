# If fzf is installed
if verify_commands fzf; then
  print_debug '  ♾️️ Loading Functions [5200] - FZF' 'yellow'
fi

## If fzf and fd are installed
if verify_commands fzf fd; then
  _fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
  }

  _fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
  }

  # verify if the .fzf-git folder exits
  if [ -d ~/.dotfiles/.fzf-git ]; then
    source ~/.dotfiles/.fzf-git/fzf-git.sh
  fi
fi
