if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Loading Update Functions'
}

function update-dotnet-tools {
    if (!(Get-Command "dotnet" -ErrorAction SilentlyContinue)) { 
        Write-Err "Dotnet not installed"
        return
    }

    Write-Title "Updading Dotnet Tools"

    $dotnet_tools = dotnet tool list -g 
    for ($i = 0; $i -lt $dotnet_tools.Count; $i++) {
        Write-Host $dotnet_tools[$i]
        
        if ($i -le 1) { continue }

        $dotnet_tool = $dotnet_tools[$i].split(" ")[0]
        & dotnet tool update -g $dotnet_tool
    }
}



function update-pythonmodules {
    if (!(Get-Command "python" -ErrorAction SilentlyContinue)) { 
        Write-Err "python not installed"
        return
    }

    Write-Title "Updating Python Modules"
    pip install --upgrade pip
    pip freeze | ForEach-Object { $_.split('==')[0] } | ForEach-Object { pip install --upgrade $_ }
}



function update-windows {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Title "Updating Windows"
        Get-WindowsUpdate
        Install-WindowsUpdate
    }
}


function update-winget {
    if (!(Get-Command "winget" -ErrorAction SilentlyContinue)) { 
        Write-Err "winget not installed"
        return
    }

    Write-Title "Updating Winget Packages"
    & winget upgrade --all --rainbow -s winget
}

if (Get-Command "scoop" -ErrorAction SilentlyContinue) {
    function Refresh-Scoop-Buckets {
        Param(
            [Parameter(Mandatory = $true, Position = 0)]
            [string]$scoop_bucket
        )

        scoop bucket rm $scoop_bucket
        scoop bucket add $scoop_bucket
    }
}


function update-scoop {
    if (!(Get-Command "scoop" -ErrorAction SilentlyContinue)) { 
        Write-Err "scoop not installed"
        return
    }

    Write-Title "Updating Scoop"
    try {
        if (Get-Command "sfsu" -ErrorAction SilentlyContinue) {
            sfsu cache remove
        }
        else {
            scoop cache rm --all
        }
        
    }
    catch {
        Write-Host " "
        Write-Err "Error Cleaning Cache : $($_.Exception.Message)"
        Show-Notification "Error Cleaning Cache" $_.Exception.Message
    }

    try {
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            & scoop cleanup -g --all --ErrorAction SilentlyContinue
        }
        else {
            & scoop cleanup --all
        }
    }
    catch {
        Write-Host " "
        Write-Err "Error running Scoop Cleanup : $($_.Exception.Message)"
        Show-Notification "Error running Scoop Cleanup" $_.Exception.Message
    }
    
    try {
        & scoop update --all
    }
    catch {
        Write-Host " "
        Write-Err "Error Updating Scoop Packages : $($_.Exception.Message)"
        Show-Notification "Error Updating Scoop Packages" $_.Exception.Message
    }
}


function update-npm {
    if (!(Get-Command "npm" -ErrorAction SilentlyContinue)) { 
        Write-Err "node and npm not installed"
        return
    }

    Write-Title "Updating NPM Package Manager"
    & npm install -g npm
}



function update-choco {
    if (!(Get-Command "choco" -ErrorAction SilentlyContinue)) { 
        Write-Err "chocolatey not installed"
        return
    }

    if (AmIAdmin) {
        Write-Title "Updating Chocolatey packages"
        & choco upgrade all -y
    }
}


function update {
    Param(
        [Parameter(Mandatory = $false, Position = 0)]
        [ValidateSet("all", "scoop", "choco", "npm", "dotnet", "python", "winget", "windows")]
        [string]$tool = "all"
    )

    $tool = $tool.ToLower()

    if ($tool -eq "all") {
        if (Get-Command "winfetch" -ErrorAction SilentlyContinue) {
            winfetch
        }
    }

    if ($tool -eq "all" -or $tool -eq "scoop") {
        update-scoop
    }

    if ($tool -eq "all" -or $tool -eq "choco") {
        update-choco
    }

    if ($tool -eq "all" -or $tool -eq "npm") {
        update-npm
    }

    if ($tool -eq "all" -or $tool -eq "dotnet") {
        update-dotnet-tools
    }

    if ($tool -eq "all" -or $tool -eq "python") {
        update-pythonmodules
    }

    if ($tool -eq "all" -or $tool -eq "winget") {
        update-winget
    }

    if ($tool -eq "all" -or $tool -eq "windows") {
        update-windows
    }
}