# If fzf is installed 
if command -v fzf >/dev/null 2>&1; then
if [[ "$DEBUG_DOTFILES" == "true" ]]; then
    print -P '%F{yellow} Loading Functions [5200] - FZF'
fi
fi

## If fzf and fd are installed
if command -v fzf >/dev/null 2>&1 && command -v fd >/dev/null 2>&1; then
  if [[ "$DEBUG_DOTFILES" == "true" ]]; then
      echo "Loading Environment Variables [FZF and FD]..."
  fi
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

