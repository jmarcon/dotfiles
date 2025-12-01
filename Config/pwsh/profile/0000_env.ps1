# Check if debug mode is enabled and log the loading of environment variables
if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Loading Env Variables'
}

# Ensure USERPROFILE is set, defaulting to HOME if not
if (-not $Env:USERPROFILE) {
    $ENV:USERPROFILE = $HOME
}

# Set HOME and CFG_DIR environment variables
$ENV:HOME = $Env:USERPROFILE
$ENV:CFG_DIR = Join-Path -Path $ENV:USERPROFILE -ChildPath ".config"

# Check if the env.ps1 file exists in the CFG_DIR
if (Test-Path -Path (Join-Path -Path $ENV:CFG_DIR -ChildPath "env.ps1")) {
    # Source the env.ps1 file
    . (Join-Path -Path $ENV:CFG_DIR -ChildPath "env.ps1")
} else {
    # Log that env.ps1 was not found and create it
    Write-Host 'env.ps1 Not Found!'
    Write-Host 'Creating env.ps1'
    
    # Ensure the CFG_DIR exists, create it if not
    if (-not (Test-Path -Path $ENV:CFG_DIR)) {
        New-Item -Path $ENV:CFG_DIR -ItemType Directory -Force
        # Set the directory to be hidden
        $dir = Get-Item -Path $ENV:CFG_DIR
        $dir.Attributes = 'Hidden'
    }
    
    # Create the env.ps1 file
    New-Item -Path $ENV:CFG_DIR -Name "env.ps1" -ItemType File -Force
    Write-Host " -- "
    Write-Host ("Please add your environment variables to " + (Join-Path -Path $ENV:CFG_DIR -ChildPath "env.ps1"))
}

# Set DOTNET_ROOT, NVM_HOME, and NVM_SYMLINK environment variables
$ENV:DOTNET_ROOT = Join-Path -Path $Env:USERPROFILE -ChildPath "apps\dotnet"
$DOTNET_ROOT = Join-Path -Path $Env:USERPROFILE -ChildPath "apps\dotnet"
$ENV:NVM_HOME = Join-Path -Path $Env:USERPROFILE -ChildPath "scoop\apps\nvm\current"
$ENV:NVM_SYMLINK = Join-Path -Path $Env:USERPROFILE -ChildPath "scoop\persist\nvm\nodejs\nodejs"


# If direnv is installed, set up its hook for PowerShell
if (Get-Command "direnv" -ErrorAction SilentlyContinue) {
    Invoke-Expression "$(direnv hook pwsh)"
}