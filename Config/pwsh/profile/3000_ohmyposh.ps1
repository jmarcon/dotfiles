if (!(Get-Command "oh-my-posh" -ErrorAction SilentlyContinue)) { exit }

if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Setting Oh-My-Posh'
}

function Set-PoshPrompt {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Theme
    )

    oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/$Theme.omp.json | Invoke-Expression
}

Set-PoshPrompt "atomic"

# oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/atomic.omp.json | Invoke-Expression