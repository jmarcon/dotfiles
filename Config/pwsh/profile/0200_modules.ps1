if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Loading Modules'
}

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile" -ErrorAction SilentlyContinue
}

$modules_to_load = @(
    "scoop-completion"
    "PSReadLine"
    "PSFzf"
    "PSProfiler"
    "PSColors"
    "posh-git"
    "posh-docker"
    "PSWriteColor"
    "Foil"
)

foreach ($module in $modules_to_load) {
    Import-Module -Name $module -ErrorAction SilentlyContinue
}

