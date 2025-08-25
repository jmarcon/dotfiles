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

foreach ($module in $modules_to_load) {
    Try {
        if ($ENV:OSTYPE -and $ENV:OSTYPE.Contains("darwin") -eq $true) {
            if ($module.Contains("PSProfiler") -eq $true) { continue }
            if ($module.Contains("PSColors") -eq $true) { continue }
        }

        Import-Module -Name "$module" -ErrorAction Stop
    }
    Catch {
        Write-Host "An error occurred on line: $($_.InvocationInfo.ScriptLineNumber) for loading module $module"
        Write-Host "Error message: $($_.Exception.Message)"
    }
}

