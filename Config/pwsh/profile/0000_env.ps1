if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Loading Env Variables'
}

if(-not $Env:USERPROFILE) {
    $ENV:USERPROFILE = $HOME
}


$ENV:HOME = $Env:USERPROFILE
$ENV:CFG_DIR = $ENV:USERPROFILE + "\.config"

if ( Test-Path $ENV:CFG_DIR\env.ps1 ) {
    . $ENV:CFG_DIR\env.ps1
}
else {
    Write-Host 'env.ps1 Not Found!'
    Write-Host 'Creating env.ps1'
    if (!(Test-Path "$ENV:CFG_DIR")) {
        New-Item -Path $ENV:CFG_DIR -ItemType Directory -Force
        # Set the directory to be hidden
        $dir = Get-Item $ENV:CFG_DIR
        $dir.Attributes = 'Hidden'
    }
    
    New-Item -Path $ENV:CFG_DIR -Name env.ps1 -ItemType File -Force
    Write-Host " -- "
    Write-Host ("Please add your environment variables to " + $ENV:CFG_DIR + "\env.ps1")
}

$ENV:DOTNET_ROOT = $Env:USERPROFILE + '\apps\dotnet\'
$ENV:NVM_HOME = $Env:USERPROFILE + "\scoop\apps\nvm\current"  
$ENV:NVM_SYMLINK = $Env:USERPROFILE + "\scoop\persist\nvm\nodejs\nodejs"