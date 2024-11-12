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

if (Get-Command "eza" -ErrorAction SilentlyContinue) {
    Remove-Alias -Name ls -Force -ErrorAction SilentlyContinue
    Remove-Alias -Name la -Force -ErrorAction SilentlyContinue
    Remove-Alias -Name ll -Force -ErrorAction SilentlyContinue

    $ic = @("--icons=always", "--color=always", "--no-time")
    $la = @("--long", "--all")
    $tr = @("--tree", "--group-directories-first", "--all")

    function ls { eza $ic $args }
    function la { eza $ic --all $args }
    function ll { eza $ic $la $args }
    function lc { eza $ic --long $args }
    function lh { eza $ic $la -h $args }
    function lg { eza $ic $la --group-directories-first $args }
    function lt { eza $ic $tr --level=2 $args }
    function lt1 { eza $ic $tr --level=1 $args }
    function lt2 { eza $ic $tr --level=2 $args }
    function lt3 { eza $ic $tr --level=3 $args }
    function lt4 { eza $ic $tr --level=4 $args }
    function l { eza $ic --no-filesize --no-time --no-user --no-permissions --long $tr --level=1 $args }
}
else {
    function ll {
        Get-ChildItem | Format-Table Mode, @{N = 'Owner'; E = { (Get-Acl $_.FullName).Owner } }, Length, LastWriteTime, @{N = 'Name'; E = { if ($_.Target) { $_.Name + ' -> ' + $_.Target } else { $_.Name } } }
    }

    function la {
        Get-ChildItem -Force @args 
    }
}

if (Get-Command "fzf" -ErrorAction SilentlyContinue) {
    if (Get-Command "bat" -ErrorAction SilentlyContinue) {
        function fzfp {
            fzf.exe --preview 'bat --style=plain --color=always {}' $args
        }
    }
}