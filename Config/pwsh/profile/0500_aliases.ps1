if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Setting Aliases'
}

if (Get-Command "btop" -ErrorAction SilentlyContinue) {
    Set-Alias top btop
    Set-Alias bpytop btop
}

if (Get-Command "nvim" -ErrorAction SilentlyContinue) {
    Set-Alias vim nvim
}

if (Get-Command "winfetch" -ErrorAction SilentlyContinue) { 
    set-alias nf winfetch
    set-alias about winfetch
    set-alias system winfetch
    set-alias lsb_release winfetch
}

if (Get-Command "bat" -ErrorAction SilentlyContinue) {
    # Set-Alias cat "bat" -Option AllScope
    # Alias doesn't work with arguments
    Remove-Alias -Name cat -Force -ErrorAction SilentlyContinue
    function cat {
        bat  -P --theme Dracula --style plain $args
    }
}

if (-not(Get-Command "docker" -ErrorAction SilentlyContinue)) {
    if (Get-Command "podman" -ErrorAction SilentlyContinue) {
        Set-Alias docker podman
    }
}

if (Get-Command "python3" -ErrorAction SilentlyContinue) { 
    Set-Alias python "python3"
}

if (Get-Command "fzf" -ErrorAction SilentlyContinue) {
    if (Get-Command "bat" -ErrorAction SilentlyContinue) {
        function fzfp {
            fzf.exe --preview 'bat --style=plain --color=always {}' $args
        }
    }
}