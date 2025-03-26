
$scoop_bucket = @(
    "extras"
    "java"
    "main"
    "nerd-fonts"
    "nonportable"
    "versions"
)

foreach ($bucket in $scoop_bucket) {
    scoop bucket add $bucket
}

scoop update

$scoop_main_packages = @(
    "7zip"
    "aws"
    "base64"
    "bat"
    "bombardier"
    "btop"
    "cacert"
    "clink"
    "clink-completions"
    "clipboard"
    "cloudflared"
    "composer"
    "ctop"
    "curl"
    "curlie"
    "dark"
    "docker-compose"
    "dua"
    "duf"
    "eza"
    "fd"
    "fzf"
    "gawk"
    "gcc"
    "gh"
    "git"
    "glow"
    "graphviz"
    "gzip"
    "helm"
    "ijhttp"
    "imagemagick"
    "innounp"
    "jid"
    "jq"
    "k6"
    "k9s"
    "kind"
    "kops"
    "krew"
    "kubectl"
    "kubectx"
    "kubefwd"
    "kubens"
    "lazydocker"
    "make"
    "neovim"
    "nvm"
    "oh-my-posh"
    "openssl"
    "pwsh"
    "ripgrep"
    "rye"
    "sed"
    "touch"
    "unzip"
    "uv"
    "walk"
    "wget"
    "which"
    "winfetch"
    "wttop"
    "yq"
    "zoxide"
)

foreach ($package in $scoop_main_packages) {
    scoop install $package
}


$scoop_extras_packages = @(
    "Terminal-Icons"
    "bruno"
    "eartrumpet"
    "jenv"
    "lazy-posh-git"
    "lazygit"
    "plantuml"
    "posh-docker"
    "posh-git"
    "powertoys"
    "psfzf"
    "psreadline"
    "scoop-completions" 
    "upscayl"
    "vlc"
    "vscode"
)

foreach ($package in $scoop_extras_packages) {
    scoop install $package
}

$scoop_fonts = @(
    "Cascadia-Code"
    "CascadiaCode-NF"
    "DejaVuSansMono-NF"
    "FiraCode"
    "FiraCode-NF"
    "Font-Awesome"
    "Inconsolata-NF"
    "Iosevka-NF"
    "JetBrainsMono-NF"
    "Meslo-NF"
    "Monoid-NF"
    "RobotoMono-NF"
)

foreach ($package in $scoop_fonts) {
    scoop install $package -k
}

