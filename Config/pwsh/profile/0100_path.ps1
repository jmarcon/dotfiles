if ($ENV:PROFILE_DEBUG -eq $true) { 
    Write-Host 'Loading Path' 
}

function Remove-Path {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $ENV:PATH = $ENV:PATH -replace [regex]::Escape($Path), ''
    $ENV:PATH = $ENV:PATH -replace ';;', ';' -replace '^;|;$', ''
}

function Add-Path {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if ($ENV:PATH -notlike '*;') {
        $ENV:PATH += ';'
    }
    $ENV:PATH += $Path
}

function Remove-Path-UserProfile {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    Remove-Path ($Env:USERPROFILE + $Path)
}

function Add-Path-UserProfile {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if ($ENV:PATH -notlike '*;') {
        $ENV:PATH += ';'
    }
    $ENV:PATH += $Env:USERPROFILE + $Path
}
Add-Path-UserProfile "\scoop\apps\nvm\current"
Add-Path-UserProfile "\scoop\apps\nvm\current\nodejs\nodejs"
Add-Path-UserProfile "\scoop\apps\oh-my-posh\current"
Add-Path-UserProfile "\scoop\apps\vscode\current\bin"

# User scripts and tools
Add-Path-UserProfile "\.scripts"
Add-Path-UserProfile "\.krew\bin"

Remove-Path-UserProfile "\.dotnet\tools"
Add-Path-UserProfile "\.dotnet\tools"

# Remove-Path-UserProfile "\apps\dotnet"
# Add-Path-UserProfile "\apps\dotnet"


# AppData paths
Add-Path-UserProfile "\AppData\local\multipass\bin"

# Dotnet path
if ($ENV:DOTNET_ROOT -ne $null -and $ENV:DOTNET_ROOT -ne '') {
    Remove-Path "C:\Program Files\dotnet\"
    Remove-Path-UserProfile "\AppData\Local\Microsoft\dotnet\"
    
    Add-Path $ENV:DOTNET_ROOT
}
