if ($env:PROFILE_DEBUG -eq $true) {
    Write-Host "Loading Modules"
}

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path("$ChocolateyProfile")) {
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
    "Microsoft.PowerShell.ConsoleGuiTools"
)

if ($env:TERM -eq "dumb" -or [Environment]::GetCommandLineArgs() -contains "-NonInteractive" -or $Host.Name -eq "ConsoleHost") {
    # Não carrega recursos que dependem de terminal interativo
    $env:SKIP_PSCOLORS = $true
}

foreach ($module in $modules_to_load) {
    Try {
        if ($ENV:OSTYPE -and $ENV:OSTYPE.Contains("darwin") -eq $true) {
            if ($module.Contains("PSProfiler") -eq $true) { continue }
            if ($module.Contains("PSColors") -eq $true) { continue }
        }

        if ($module.Contains("PSColors") -eq $true) {
            if (-not $env:SKIP_PSCOLORS -and $Host.Name -eq "ConsoleHost") { 
                Import-Module -Name "$module" -ErrorAction Stop
            }
            else {
                continue
            }
        }   

        Import-Module -Name "$module" -ErrorAction Stop
    }
    Catch {
        Write-Host "An error occurred on line: $($_.InvocationInfo.ScriptLineNumber) for loading module $module"
        Write-Host "Error message: $($_.Exception.Message)"
    }
}

