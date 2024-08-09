if (!(Get-Command "oh-my-posh" -ErrorAction SilentlyContinue)) { exit }

if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Setting Oh-My-Posh'
}

oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/atomic.omp.json | Invoke-Expression