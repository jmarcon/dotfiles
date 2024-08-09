if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Loading Path'
}

function Add-Path {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $ENV:PATH += ';' + $Path
}

function Add-Path-UserProfile {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $ENV:PATH += ';' + $Env:USERPROFILE + $Path
}

# Scoop
Add-Path-UserProfile "\scoop\shims"
Add-Path-UserProfile "\scoop\apps\nvm\current"
Add-Path-UserProfile "\scoop\apps\nvm\current\nodejs\nodejs"
Add-Path-UserProfile "\scoop\apps\oh-my-posh\current"
Add-Path-UserProfile "\scoop\apps\vscode\current\bin"


Add-Path-UserProfile "\.scripts"
Add-Path-UserProfile "\.krew\bin"
Add-Path-UserProfile "\.dotnet\tools"



# AppData
Add-Path-UserProfile "\AppData\local\multipass\bin"

# Dotnet
Add-Path $ENV:DOTNET_ROOT


