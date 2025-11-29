if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Loading Update Functions'
}

function update-dotnet {
    # Verify if the dotnet-install.ps1 script is in the downloads folder
    $downloadsFolder = [System.IO.Path]::Combine($env:USERPROFILE, "Downloads")
    $dotnetInstaller = [System.IO.Path]::Combine($downloadsFolder, "dotnet-install.ps1")

    if (!(Test-Path $dotnetInstaller)) {
        # Download the script
        Invoke-WebRequest -Uri "https://dot.net/v1/dotnet-install.ps1" -OutFile $dotnetInstaller
    }

    Write-Title "Updating Dotnet Versions SDKS : 6.0, 7.0, 8.0, 9.0, 10.0"

    & $dotnetInstaller -InstallDir $DOTNET_ROOT -Channel 6.0
    & $dotnetInstaller -InstallDir $DOTNET_ROOT -Channel 7.0
    & $dotnetInstaller -InstallDir $DOTNET_ROOT -Channel 8.0
    & $dotnetInstaller -InstallDir $DOTNET_ROOT -Channel 9.0
    & $dotnetInstaller -InstallDir $DOTNET_ROOT -Channel 10.0
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

function update-nvim-lazy() {
    if (!(Get-Command "nvim" -ErrorAction SilentlyContinue)) { 
        Write-Err "Neovim not installed"
        return
    }

    Write-Title "Updating Neovim Plugins"
    nvim --headless "+Lazy! update" +qa
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
    if ($ENV:OSTYPE -and $ENV:OSTYPE.Contains("darwin") -eq $true) { 
        Write-Err "Impossible to update Windows! Running on MacOS"
        return 
    }

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

function update-vscode {
    if (!(Get-Command "scoop" -ErrorAction SilentlyContinue)) { 
        Write-Err "scoop not installed"
        return
    }

    Write-Title "Force Updating Visual Studio Code"
    Write-Host "Killing code instances and code-tunnel"
    Get-Process -Name "code-*","Code*" | kill 
    Write-Host "Updating vscode from Scoop"
    scoop update vscode
    Write-Host "Installing code tunnel again"
    code tunnel service install
}

function update {
    Param(
        [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
        [string[]]$tool = $("all")
    )

    # Convert all arguments to lowercase for easier comparison
    $tool = $tool | ForEach-Object { $_.ToLower() }
    $parallel = ($tool -contains "--parallel" -or $tool -contains "-p")
    if ($parallel) {
        $tool = $tool | Where-Object { $_ -ne "--parallel" -and $_ -ne "-p" }
    }

    $help = ($tool -contains "--help" -or $tool -contains "-h" -or $tool -contains "-?" -or $tool -contains "/?")
    if ($help) {
        $tool = $tool | Where-Object { $_ -ne "--help" -and $_ -ne "-h" -and $_ -ne "-?" -and $_ -ne "/?" }
    }
    

    # Check for help flag
    if ($help) {
        Write-Host ""
        Write-Host "UPDATE FUNCTION" -ForegroundColor Green
        Write-Host "===============" -ForegroundColor Green
        Write-Host ""
        Write-Host "DESCRIPTION:" -ForegroundColor Cyan
        Write-Host "  Updates various development tools and package managers."
        Write-Host ""
        Write-Host "USAGE:" -ForegroundColor Cyan
        Write-Host "  update [--parallel] [tool1] [tool2] ... [--help]"
        Write-Host ""
        Write-Host "OPTIONS:" -ForegroundColor Cyan
        Write-Host "  --parallel   Run updates in parallel (faster, but less readable output) (-p)"
        Write-Host "  --help       Display this help message (-h, -?, /?)"
        Write-Host ""
        Write-Host "TOOLS:" -ForegroundColor Cyan
        Write-Host "  all          Update all available tools (default)"
        Write-Host "  scoop        Update Scoop packages"
        Write-Host "  choco        Update Chocolatey packages (requires admin)"
        Write-Host "  npm          Update NPM package manager"
        Write-Host "  dotnet       Update .NET SDKs and global tools"
        Write-Host "  python       Update Python pip and all installed modules"
        Write-Host "  winget       Update packages via Windows Package Manager"
        Write-Host "  windows      Update Windows (requires admin)"
        Write-Host "  code         Force update Visual Studio Code"
        Write-Host ""
        Write-Host "EXAMPLES:" -ForegroundColor Cyan
        Write-Host "  update                    # Update all tools sequentially"
        Write-Host "  update --help             # Display this help message"
        Write-Host "  update --parallel         # Update all tools in parallel"
        Write-Host "  update scoop npm          # Update only Scoop and NPM"
        Write-Host "  update --parallel scoop   # Update Scoop in parallel mode"
        Write-Host ""
        return
    }

    # If no tools specified after removing flags, default to "all"
    if ($tool.Count -eq 0) {
        $tool = @("all")
    }

    # Executa winfetch primeiro se for "all"
    if ($tool -eq "all") {
        if (Get-Command "winfetch" -ErrorAction SilentlyContinue) {
            winfetch
        }
    }

    # Obtém o caminho do perfil atual
    $profilePath = $PROFILE.CurrentUserAllHosts
    if (-not (Test-Path $profilePath)) {
        $profilePath = $PROFILE.CurrentUserCurrentHost
    }

    # Lista de jobs a serem executados
    $jobs = @()

    # Define as tarefas baseadas no parâmetro
    $tasksToRun = @()

    if ($tool -contains "all" -or $tool -contains "scoop") {
        $tasksToRun += @{
            Name = "Scoop"
            ScriptBlock = { 
                param($profilePath)
                if (Test-Path $profilePath) { 
                    . $profilePath 
                }
                update-scoop 
            }
        }
    }

    if ($tool -contains "all" -or $tool -contains "choco") {
        $tasksToRun += @{
            Name = "Chocolatey"
            ScriptBlock = { 
                param($profilePath)
                if (Test-Path $profilePath) { 
                    . $profilePath 
                }
                update-choco 
            }
        }
    }

    if ($tool -contains "all" -or $tool -contains "npm") {
        $tasksToRun += @{
            Name = "NPM"
            ScriptBlock = { 
                param($profilePath)
                if (Test-Path $profilePath) { 
                    . $profilePath 
                }
                update-npm 
            }
        }
    }

    if ($tool -contains "all" -or $tool -contains "dotnet") {
        $tasksToRun += @{
            Name = "DotNet"
            ScriptBlock = { 
                param($profilePath)
                if (Test-Path $profilePath) { 
                    . $profilePath 
                }
                update-dotnet
                update-dotnet-tools
            }
        }
    }

    if ($tool -contains "all" -or $tool -contains "python") {
        $tasksToRun += @{
            Name = "Python"
            ScriptBlock = { 
                param($profilePath)
                if (Test-Path $profilePath) { 
                    . $profilePath 
                }
                update-pythonmodules 
            }
        }
    }
    if ($tasksToRun.Count -gt 0) {
        if ($parallel) {
            Write-Host "Starting $($tasksToRun.Count) task(s) in parallel..." -ForegroundColor Green

            foreach ($task in $tasksToRun) {
                $job = Start-Job -Name $task.Name -ScriptBlock $task.ScriptBlock -ArgumentList $profilePath
                $jobs += $job
                Write-Host "♾️   Updating $($task.Name)" -ForegroundColor Cyan
            }

            Write-Host "`nMonitoring jobs..." -ForegroundColor Yellow

            do {
                $runningJobs = $jobs | Where-Object { $_.State -eq "Running" }
                $completedJobs = $jobs | Where-Object { $_.State -eq "Completed" }
                $failedJobs = $jobs | Where-Object { $_.State -eq "Failed" }

                Write-Host "`r[Running: $($runningJobs.Count) | Completed: $($completedJobs.Count) | Failed: $($failedJobs.Count)]" -NoNewline -ForegroundColor White
                Start-Sleep -Seconds 1

            } while ($runningJobs.Count -gt 0)

            Write-Host "`n`nAll tasks have completed!" -ForegroundColor Green

            foreach ($job in $jobs) {
                Write-Host "`n--- Result: $($job.Name) ---" -ForegroundColor Magenta

                if ($job.State -eq "Completed") {
                    Write-Host "✓ Success" -ForegroundColor Green
                    $result = Receive-Job -Job $job
                    if ($result) {
                        $result | Write-Host
                    }
                }
                elseif ($job.State -eq "Failed") {
                    Write-Host "✗ Failed" -ForegroundColor Red
                    $error = Receive-Job -Job $job 2>&1
                    if ($error) {
                        $error | Write-Host -ForegroundColor Red
                    }
                }

                Remove-Job -Job $job
            }

            Write-Host "`nAll updates completed!" -ForegroundColor Green
        }
        else {
            Write-Host "Starting $($tasksToRun.Count) task(s) sequentially..." -ForegroundColor Green

            $completedCount = 0
            $failedCount = 0

            foreach ($task in $tasksToRun) {
                Write-Host "`n♾️   Updating $($task.Name)..." -ForegroundColor Cyan

                try {
                    & $task.ScriptBlock $profilePath
                    Write-Host "✓ $($task.Name) completed successfully" -ForegroundColor Green
                    $completedCount++
                }
                catch {
                    Write-Host "✗ Error running $($task.Name): $($_.Exception.Message)" -ForegroundColor Red
                    $failedCount++
                }
            }

            Write-Host "`n--- Summary ---" -ForegroundColor Magenta
            Write-Host "Completed: $completedCount" -ForegroundColor Green
            Write-Host "Failed: $failedCount" -ForegroundColor Red
            Write-Host "`nAll updates completed!" -ForegroundColor Green
        }
    }

    if ($tool -contains "all" -or $tool -contains "winget") {
        update-winget 
    }

    if ($tool -contains "all" -or $tool -contains "windows") {
        update-windows 
    }

    if ($tool -contains "code") {
        update-vscode 
    }
}