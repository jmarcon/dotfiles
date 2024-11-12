# Set debug mode for the profile
$ENV:PROFILE_DEBUG = $false

# Set the profile path if not already set
if ($null -eq $ENV:PROFILE_PATH) {
    $ENV:PROFILE_PATH = 'J:\Scripts\profile\'
}

# Function to open a profile file
function Open-Profile-File {
    Param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$file_name
    )

    $profile_file_path = Join-Path -Path $ENV:PROFILE_PATH -ChildPath "$file_name.ps1"
    return $profile_file_path
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
)

# Loop through each profile file and load it if it exists
foreach ($pfile in $pfiles) {
    $ipf = Open-Profile-File $pfile

    if (-not ($PSVersionTable.PSVersion.Major -ge 7)) {
        # Skip github integration for older versions of powershell
        if ($pfile -eq '1500_github_integration') {
            continue
        }
    }

    if (Test-Path ($ipf)) {
        . $ipf
    }
    else {
        Write-Host "$ipf Not Found"
    }
}