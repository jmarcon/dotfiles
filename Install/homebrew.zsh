#!/bin/zsh
# Install homebrew

# Verify if homebrew is installed
if [ -x "$(command -v brew)" ]; then
  echo "Homebrew is already installed"
else
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
``
## List of packages to install
declare -a pkgs=(
    "ack"
    "azure-cli"
    "bat"
    "bpytop"
    "btop"
    "ca-certificates"
    "duf"
    "dysk"
    "eza"
    "fd"
    "fzf"
    "gh"
    "git"
    "git-delta"
    "git-extras"
    "git-flow"
    "helm"
    "htop"
    "httpie"
    "jenv"
    "jq"
    "julia"
    "k6"
    "k9s"
    "krew"
    "kubernetes-cli"
    "lua"
    "luajit"
    "luarocks"
    "neofetch"
    "neovim"
    "nvm"
    "oh-my-posh"
    "openjdk"
    "openjdk@11"
    "openjdk@17"
    "openssl@1.1"
    "openssl@3"
    "perl"
    "plantuml"
    "php"
    "pyenv"
    "rbenv"
    "ripgrep"
    "ruby"
    "tree"
    "wrk"
    "zoxide"
    "zsh"
    "zsh-completions"
    "zsh-syntax-highlighting"
)

## Install packages
for package in "${pkgs[@]}"; do
  if ! brew list "$package" &> /dev/null; then
    echo "Installing $package"
    brew install "$package"
  fi
done

## Install casks if on macOS
if [ "$(uname)" == "Darwin" ]; then
  declare -a casks=(
    "alfred"
    "daisydisk"
    "dbeaver-community"
    "google-chrome"
    "insomnia"
    "iterm2"
    "jetbrains-toolbox"
    "microsoft-edge"
    "mindmac"
    "powershell"
    "setapp"
    "superlist"
    "transmit"
    "visual-studio-code"
    "warp"
  )

  ## Install casks
  for cask in "${casks[@]}"; do
    if ! brew list --cask "$cask" &> /dev/null; then
      echo "Installing $cask"
      brew install "$cask"
    fi
  done
fi
