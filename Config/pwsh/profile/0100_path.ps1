if ($ENV:PROFILE_DEBUG -eq $true) { 
    Write-Host 'Loading Path' 
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
Add-Path-UserProfile "\.dotnet\tools"

# AppData paths
Add-Path-UserProfile "\AppData\local\multipass\bin"

# Dotnet path
if ($ENV:DOTNET_ROOT -ne $null -and $ENV:DOTNET_ROOT -ne '') {
    Add-Path $ENV:DOTNET_ROOT
}
