if (!(Get-Command "oh-my-posh" -ErrorAction SilentlyContinue)) { exit }

DEBUG_WRITE 'Setting Oh-My-Posh'
$Global:DEFAULT_POSH_THEME="atomic"

function Set-PoshPrompt {
    Param(
        [Parameter(Mandatory = $false)]
        [string]$Theme = $Global:DEFAULT_POSH_THEME
    )

    DEBUG_WRITE "Setting Oh-My-Posh theme to: $Theme"

    # if not $env:POSH_THEMES_PATH is set, set it to default location
    if (-not $env:POSH_THEMES_PATH) {

        $env:POSH_THEMES_PATH = "$(scoop prefix oh-my-posh)\themes"
    }

    oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/$Theme.omp.json | Invoke-Expression
}

function Set-PoshTheme {
    Param(
        [Parameter(Mandatory = $false)]
        [string]$themeReason = "dev"
    )

    DEBUG_WRITE "Choosing Oh-My-Posh theme for reason: $themeReason"

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
        Set-PoshPrompt $DEFAULT_POSH_THEME
    }
}

Set-PoshPrompt

# oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/atomic.omp.json | Invoke-Expression