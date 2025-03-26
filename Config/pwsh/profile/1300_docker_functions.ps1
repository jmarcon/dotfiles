if (!(Get-Command "docker" -ErrorAction SilentlyContinue)) { exit }

if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Loading Docker Functions'
}

function dps {
    & docker ps -a
}
