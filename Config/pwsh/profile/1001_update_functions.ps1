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

    Write-Title "Updading Dotnet Versions"

    & $dotnetInstaller -InstallDir $DOTNET_ROOT -Channel 6.0
    & $dotnetInstaller -InstallDir $DOTNET_ROOT -Channel 7.0
    & $dotnetInstaller -InstallDir $DOTNET_ROOT -Channel 8.0
    & $dotnetInstaller -InstallDir $DOTNET_ROOT -Channel 9.0
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
        [Parameter(Mandatory = $false, Position = 0)]
        [ValidateSet("all", "scoop", "choco", "npm", "dotnet", "python", "winget", "windows", "code")]
        [string]$tool = "all"
    )

    $tool = $tool.ToLower()

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

    if ($tool -eq "all" -or $tool -eq "scoop") {
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

    if ($tool -eq "all" -or $tool -eq "choco") {
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

    if ($tool -eq "all" -or $tool -eq "npm") {
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

    if ($tool -eq "all" -or $tool -eq "dotnet") {
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

    if ($tool -eq "all" -or $tool -eq "python") {
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
        Write-Host "Iniciando $($tasksToRun.Count) tarefa(s) em paralelo..." -ForegroundColor Green

        # Inicia os jobs passando o caminho do perfil
        foreach ($task in $tasksToRun) {
            $job = Start-Job -Name $task.Name -ScriptBlock $task.ScriptBlock -ArgumentList $profilePath
            $jobs += $job
            Write-Host "✓ Iniciado: $($task.Name)" -ForegroundColor Cyan
        }

        # Monitora o progresso dos jobs
        Write-Host "`nMonitorando progresso dos jobs..." -ForegroundColor Yellow
        
        do {
            $runningJobs = $jobs | Where-Object { $_.State -eq "Running" }
            $completedJobs = $jobs | Where-Object { $_.State -eq "Completed" }
            $failedJobs = $jobs | Where-Object { $_.State -eq "Failed" }
            
            Write-Host "`r[Running: $($runningJobs.Count) | Completed: $($completedJobs.Count) | Failed: $($failedJobs.Count)]" -NoNewline -ForegroundColor White
            Start-Sleep -Seconds 1
            
        } while ($runningJobs.Count -gt 0)

        Write-Host "`n`nTodas as tarefas finalizaram!" -ForegroundColor Green

        # Exibe resultados e limpa os jobs
        foreach ($job in $jobs) {
            Write-Host "`n--- Resultado: $($job.Name) ---" -ForegroundColor Magenta
            
            if ($job.State -eq "Completed") {
                Write-Host "✓ Sucesso" -ForegroundColor Green
                $result = Receive-Job -Job $job
                if ($result) {
                    $result | Write-Host
                }
            }
            elseif ($job.State -eq "Failed") {
                Write-Host "✗ Falhou" -ForegroundColor Red
                $error = Receive-Job -Job $job 2>&1
                if ($error) {
                    $error | Write-Host -ForegroundColor Red
                }
            }
            
            Remove-Job -Job $job
        }

        Write-Host "`nTodas as atualizações concluídas!" -ForegroundColor Green
    }

    if ($tool -eq "all" -or $tool -eq "winget") {
        update-winget 
    }

    if ($tool -eq "all" -or $tool -eq "windows") {
        update-windows 
    }

    if ($tool -eq "code") {
        update-vscode 
    }
}