# Set debug mode for the profile
$ENV:PROFILE_DEBUG = $false

# Set the profile path if not already set
if ($null -eq $ENV:PROFILE_PATH) {
    # Use the directory where this script is located
    $ENV:PROFILE_PATH = $PSScriptRoot
    if ($ENV:PROFILE_DEBUG -eq $true) {
        Write-Host "Set PROFILE_PATH to: $ENV:PROFILE_PATH" -ForegroundColor Magenta
    }
}
else {
    if ($ENV:PROFILE_DEBUG -eq $true) {
        Write-Host "PROFILE_PATH already set to: $ENV:PROFILE_PATH" -ForegroundColor Magenta
    }
}

# List of profile files to load
$pfiles = @(
    '0000_env'
    '0100_path'
    '0200_modules'
    '0500_aliases'
    '0750_completions'
    '1000_functions'
    '1001_update_functions'
    '1100_kubectl_functions'
    '1200_git_functions'
    '1300_docker_functions'
    '1500_github_integration'
    '2000_startup'
    '3000_ohmyposh'
    '4000_psreadline_profile'
    '5000_tools'
    '6000_ai'
)

# Loop through each profile file and load it if it exists
foreach ($pfile in $pfiles) {
    $ipf = Join-Path -Path $ENV:PROFILE_PATH -ChildPath "$pfile.ps1"

    if ($ENV:PROFILE_DEBUG -eq $true) {
        Write-Host "Loading: $ipf" -ForegroundColor Cyan
    }

    if (-not ($PSVersionTable.PSVersion.Major -ge 7)) {
        # Skip github integration for older versions of powershell
        if ($pfile -eq '1500_github_integration') {
            continue
        }
    }

    if (Test-Path ($ipf)) {
        Try {
            # Load the file content and execute it with global scope prefix for functions
            $content = Get-Content -Path $ipf -Raw
            # Replace "function " with "function global:" to ensure all functions are global
            $content = $content -replace '(?m)^(\s*)function\s+(?!global:)(\w+[-\w]*)', '$1function global:$2'
            Invoke-Expression $content

            if ($ENV:PROFILE_DEBUG -eq $true) {
                Write-Host "  ✓ Loaded successfully" -ForegroundColor Green
            }
        }
        Catch {
            Write-Host "An error occurred loading $ipf" -ForegroundColor Red
            Write-Host "  Line: $($_.InvocationInfo.ScriptLineNumber)" -ForegroundColor Red
            Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "$ipf Not Found" -ForegroundColor Yellow
    }
}