# If fzf is installed
if command -v fzf >/dev/null 2>&1; then
  print_debug '  ♾️️ Loading Functions [5200] - FZF' 'yellow'
fi

## If fzf and fd are installed
if command -v fzf >/dev/null 2>&1 && command -v fd >/dev/null 2>&1; then
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
