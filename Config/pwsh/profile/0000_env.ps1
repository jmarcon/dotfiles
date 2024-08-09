if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Loading Env Variables'
}

$Env:HOME = $Env:USERPROFILE

if ( Test-Path $ENV:USERPROFILE\.Config\env.ps1 ) {
    . $ENV:USERPROFILE\.Config\env.ps1
}
else {
    Write-Host 'env.ps1 Not Found!'
    Write-Host 'Creating env.ps1'
    if (!(Test-Path "$ENV:USERPROFILE\.Config\")) {
        New-Item -Path $ENV:USERPROFILE\.Config\ -ItemType Directory -Force
        # Set the directory to be hidden
        $dir = Get-Item $ENV:USERPROFILE\.Config\
        $dir.Attributes = 'Hidden'
    }
    
    New-Item -Path $ENV:USERPROFILE\.Config\ -Name env.ps1 -ItemType File -Force
    Write-Host " -- "
    Write-Host "Please add your environment variables to " + $ENV:USERPROFILE + "\.Config\env.ps1"
}

$ENV:DOTNET_ROOT = $Env:USERPROFILE + '\apps\dotnet\'
$ENV:NVM_HOME = $Env:USERPROFILE + "\scoop\apps\nvm\current"  
$ENV:NVM_SYMLINK = $Env:USERPROFILE + "\scoop\persist\nvm\nodejs\nodejs"