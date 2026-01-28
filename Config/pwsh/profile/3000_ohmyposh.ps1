if (!(Get-Command "oh-my-posh" -ErrorAction SilentlyContinue)) { exit }

DEBUG_WRITE 'Setting Oh-My-Posh'
$Global:DEFAULT_POSH_THEME="atomic"
$Global:DEFAULT_POSH_THEME_PATH="$(scoop prefix oh-my-posh)\themes"

function Set-PoshPrompt {
    Param(
        [Parameter(Mandatory = $false)]
        [string]$Theme = $Global:DEFAULT_POSH_THEME
    )

    DEBUG_WRITE "Setting Oh-My-Posh theme to: $Theme"
    if ($env:WARP_IS_LOCAL_SHELL_SESSION -eq "1") {
        DEBUG_WRITE "Detected local shell session in Warp, using 'minimal' theme for performance"
        $Theme = "minimal"
    }

    # if not $env:POSH_THEMES_PATH is set, set it to default location
    if (-not $env:POSH_THEMES_PATH) {
        $env:POSH_THEMES_PATH = $Global:DEFAULT_POSH_THEME_PATH
    }

    if ((Test-Path "$env:POSH_THEMES_PATH/$Theme.omp.json")) {
        oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/$Theme.omp.json | Invoke-Expression
    }
    elseif ((Test-Path "$env:POSH_THEMES_PATH/$Theme.omp.toml")) {
        oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/$Theme.omp.toml | Invoke-Expression
    }
    elseif ((Test-Path "$env:POSH_THEMES_PATH/$Theme.omp.yaml")) {
        oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/$Theme.omp.yaml | Invoke-Expression
    }
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
        Set-PoshPrompt $Global:DEFAULT_POSH_THEME
    }
}

Set-PoshPrompt "radar"

# oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/atomic.omp.json | Invoke-Expression