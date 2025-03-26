#!/usr/bin/env pwsh

# Is it linux?
if ($IsLinux) {
    # $IsWsl = (-not ([string]::IsNullOrEmpty($Env:WSL_DISTRO_NAME)))
    # if ($IsWsl) {
    #     Write-Host "Linux in WSL Installation Started"
    # } else {
    #     Write-Host "Linux Installation Started"
    # }
    Write-Host "Platform: Linux"
    Write-Host "It is recommended to use zsh and follow the linux installation folder"
    return
}

# Is it macos?
if ($IsMacOS) {
    Write-Host "Platform: MacOS"
    Write-Host "It is recommended to use zsh and follow the linux installation folder"
    return
}

# Is it windows?
if ($IsWindows) {
    Write-Host "Windows Installation Started"
} else {
    Write-Host "Platform: Unknown"
    return
}

# Create the profile if it doesn't exist
New-Item -ItemType File -Path $PROFILE -Force


# Install PowerShell modules
. .\powershell_modules.ps1

# Install package managers
. .\package_managers.ps1

# Install Scoop packages
. .\scoop_packages.ps1

# Install Winget packages
. .\winget_packages.ps1

# Install Dev Environment
. .\dev_environment.ps1
