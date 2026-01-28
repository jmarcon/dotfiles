DEBUG_WRITE 'Loading Path' 

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

# Remove empty, non-existent, and duplicate directories from PATH
# Usage: clean_path
function clean_path {
    [CmdletBinding()]
    param()

    $newPath = @()
    $pathDirs = $ENV:PATH -split ';'

    foreach ($dir in $pathDirs) {
        # Skip empty directories
        if ([string]::IsNullOrWhiteSpace($dir)) {
            if ($ENV:PROFILE_DEBUG -eq $true -or $ENV:DEBUG_DOTFILES -eq "true") {
                Write-Host "Skipping empty directory in PATH" -ForegroundColor Yellow
            }
            continue
        }

        # Skip non-existent directories
        if (-not (Test-Path -Path $dir -PathType Container)) {
            if ($ENV:PROFILE_DEBUG -eq $true -or $ENV:DEBUG_DOTFILES -eq "true") {
                Write-Host "Removing non-existent directory from PATH: $dir" -ForegroundColor Red
            }
            continue
        }

        # Skip duplicates
        if ($newPath -contains $dir) {
            if ($ENV:PROFILE_DEBUG -eq $true -or $ENV:DEBUG_DOTFILES -eq "true") {
                Write-Host "Skipping duplicate directory in PATH: $dir" -ForegroundColor Yellow
            }
            continue
        }

        $newPath += $dir
    }

    $ENV:PATH = $newPath -join ';'
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

$shimPath = "$env:USERPROFILE\AppData\Local\mise\shims"
$currentPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$newPath = $currentPath + ";" + $shimPath
[Environment]::SetEnvironmentVariable('Path', $newPath, 'User')