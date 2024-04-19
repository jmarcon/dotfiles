#!/bin/zsh

# Load the OS type sourcing the os.zsh file to export the CURRENT_OS variable
# If the os.zsh exists in the same dir of this script, it will be sourced in the install.zsh
dir=$(dirname $(realpath $0))
os_file="$dir/os.zsh"
if [ -f "$os_file" ]; then
  source $os_file
fi

# If in linux 
if [ "$CURRENT_OS" = "linux" ]; then
  # If it is an Ubuntu based distro
  if command -v apt >/dev/null 2>&1; then
    ## Add repositories

    ### Add the Gierens repository for the eza package
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list

    ### Add the OpenSuse repository for the warp-terminal package
    echo 'deb http://download.opensuse.org/repositories/home:/jstaf/xUbuntu_23.10/ /' | sudo tee /etc/apt/sources.list.d/home:jstaf.list
    curl -fsSL https://download.opensuse.org/repositories/home:jstaf/xUbuntu_23.10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_jstaf.gpg > /dev/null

    ### Add the Docker repository
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    ### Add Kubernetes repository
    cho 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

    declare -a repos=(
        "ppa:boltgolt/howdy"
        "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"
        "ppa:papirus/papirus"
        "ppa:neovim-ppa/stable"
    )

    for repo in "${repos[@]}"; do
      sudo add-apt-repository -y $repo
    done

    sudo apt update
    sudo apt upgrade -y
    
    declare -a pkgs=(
        "aptitude"
        "apt-transport-https"
        "aria2"
        "autorandr"
        "browsers"
        "build-essential"
        "bzip2"
        "ca-certificates"
        "cmake"
        "containerd.io"
        "cpanminus"
        "curl"
        "docker-buildx-plugin"
        "docker-ce"
        "docker-ce-cli"
        "docker-compose-plugin"
        "dolphin"
        "eza"
        "fd-find"
        "gettext"
        "gcc"
        "git"
        "glib-networking:i386"
        "gnome-tweaks"
        "howdy"
        "kubectl"
        "libaa1"
        "libapparmor1"
        "libasound2"
        "libasound2-plugins"
        "libdatetime-perl"
        "libevdev-dev"
        "libudev-dev"
        "libconfig-dev"
        "libffi-dev"
        "libfuse2"
        "libjson-perl"
        "libncurses5-dev"
        "libgdbm-dev"
        "libnss3-dev"
        "llvm"
        "libreadline-dev"
        "libssl-dev"
        "luarocks"
        "make"
        "mpv"
        "onedriver"
        "openssl"
        "papirus-icon-theme"
        "perl"
        "php-cli"
        "python-software-properties"
        "python3-dev"
        "python3-neovim"
        "python3-pip"
        "python3-setuptools"
        "python3-wheel"
        "rbenv"
        "solaar"
        "software-properties-common"
        "warp-terminal"
        "wget"
        "x11-utils"
        "xautomation"
        "xorg-dev"
        "zliblg-dev"
        "zsh"
    )

    for pkg in "${pkgs[@]}"; do
      sudo apt install -y $pkg
    done


     (                                                                                                                                                      zsh  14:36:36 
        # Krew plugin manager for kubectl
        set -x; cd "$(mktemp -d)" &&
        OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
        ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
        KREW="krew-${OS}_${ARCH}" &&
        curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
        tar zxvf "${KREW}.tar.gz" &&
        ./"${KREW}" install krew
    )

  fi
fi