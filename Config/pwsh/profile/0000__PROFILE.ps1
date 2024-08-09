$ENV:PROFILE_DEBUG = $false
if ($null -eq $ENV:PROFILE_PATH) {
    $ENV:PROFILE_PATH = 'J:\Scripts\profile\'
}

function Open-Profile-File {
    Param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$file_name
    )

    $profile_file_path = $ENV:PROFILE_PATH + $file_name + '.ps1'
    return $profile_file_path
}

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
    '2000_startup'
    '3000_ohmyposh'
    '4000_psreadline_profile'
)

foreach ($pfile in $pfiles) {
    $ipf = Open-Profile-File $pfile
    # $ipf = $pfile
    if (Test-Path ($ipf)) {
        . $ipf
    }
    else {
        Write-Host $ipf 'Not Found'
    }
}