if (!(Get-Command "oh-my-posh" -ErrorAction SilentlyContinue)) { exit }

if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Setting Oh-My-Posh'
}

function Set-PoshPrompt {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Theme = "atomic"
    )

    oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/$Theme.omp.json | Invoke-Expression
}

function Set-PoshTheme {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$themeReason = "dev"
    )

    if ($themeReason -eq "dev") {
        Set-PoshPrompt "tokyonight_storm"
    }
    elseif ($themeReason -eq "cloud") {
        Set-PoshPrompt "cloud-context"
    }
    elseif ($themeReason -eq "work") {
        Set-PoshPrompt "easy-term"
    }
    else {
        Set-PoshPrompt "atomic"
    }
}

Set-PoshPrompt "atomic"

# oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/atomic.omp.json | Invoke-Expression