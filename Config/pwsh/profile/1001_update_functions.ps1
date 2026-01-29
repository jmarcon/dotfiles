DEBUG_WRITE 'Loading Update Functions'

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
    function Reset-ScoopBucket {
        Param(
            [Parameter(Mandatory = $true, Position = 0)]
            [string]$scoop_bucket
        )

        scoop bucket rm $scoop_bucket
        scoop bucket add $scoop_bucket
    }

    Set-Alias -Name "Refresh-Scoop-Buckets" -Value "Reset-ScoopBucket"
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
        scoop status | ForEach-Object {
            Write-Host "Updating $($_.Name)"
            try {
                & scoop update $_.Name --force
            }
            catch {
                DEBUG_WRITE "$($_.Name) failed to update : $($_.Exception.Message)"
            }
        }
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
    Get-Process -Name "code-*", "Code*" | kill 
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
            Name        = "Scoop"
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
            Name        = "Chocolatey"
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
            Name        = "NPM"
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
            Name        = "DotNet"
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
            Name        = "Python"
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
                    $jobError = Receive-Job -Job $job 2>&1
                    if ($jobError) {
                        $jobError | Write-Host -ForegroundColor Red
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

###############################################################################
# UPDATE FUNCTIONS - Ported from ZSH for cross-platform consistency
###############################################################################

# Print installed .NET SDK versions
# Usage: print_dotnet_versions
function print_dotnet_versions {
    if (verify_commands "dotnet") {
        dotnet --list-sdks | ForEach-Object {
            $version = ($_ -split '\s+')[0]
            Write-Output ".NET SDK: $version"
        }
    }
}

# Print versions of all installed development tools
# Usage: print_versions
function print_versions {
    Write-Color "Current versions:" -Color Cyan
    Write-Output "--------------------------------"

    if (verify_commands "node") { Write-Output "Node....: $(node -v)" }
    if (verify_commands "yarn") { Write-Output "Yarn....: $(yarn -v)" }
    if (verify_commands "bun") { Write-Output "Bun.....: $(bun -v)" }
    if (verify_commands "npm") { Write-Output "NPM.....: $(npm -v)" }
    if (verify_commands "python") { Write-Output "Python..: $(python --version)" }
    if (verify_commands "pyenv") { Write-Output "Pyenv...: $(pyenv --version)" }
    if (verify_commands "go") { Write-Output "Go......: $(go version)" }

    print_dotnet_versions
}

# Update Python via pyenv to latest stable version
# Usage: update_python_pyenv
function update_python_pyenv {
    if (-not (verify_commands "pyenv")) {
        return
    }

    # Get the latest version (excluding dev/alpha/beta/rc versions)
    $latestVersion = (pyenv install --list |
        Where-Object {
            $_ -notmatch 'dev|alpha|beta|rc|[a-z]' -and
            $_ -match '^\s*\d+\.\d+\.\d+\s*$'
        } |
        Select-Object -Last 1).Trim()

    # Get latest installed version
    $installedVersion = (pyenv versions --bare | Select-Object -Last 1).Trim()

    if ($installedVersion -ne $latestVersion) {
        Write-Output "--------------------------------"
        Write-Output ""
        Write-Color "Installing Python $latestVersion" -Color Yellow
        pyenv install $latestVersion
        pyenv global $latestVersion
    }
}

# Update Node.js via nvm and update NPM
# Usage: update_node
function update_node {
    if (verify_commands "nvm") {
        Write-Output "--------------------------------"
        Write-Output ""
        Write-Color "Updating Node.js" -Color Yellow
        nvm install node
        nvm use node
        nvm alias default node
    }

    if (verify_commands "npm") {
        Write-Output "--------------------------------"
        Write-Output ""
        Write-Color "Updating NPM" -Color Yellow
        npm install -g npm
        npm update -g
    }
}

# Update macOS system
# Usage: update_macos
function update_macos {
    if (verify_commands "softwareupdate") {
        Write-Output "--------------------------------"
        Write-Output ""
        Write-Color "📦 Updating macOS..." -Color Yellow
        softwareupdate --install --all --agree-to-license
    }
}

# Update Mac App Store applications
# Usage: update_macos_apps
function update_macos_apps {
    if (-not (verify_commands "mas")) {
        return
    }

    Write-Output "--------------------------------"
    Write-Output ""

    # Get outdated apps
    $masOutdated = mas outdated | ForEach-Object { ($_ -split '\s+')[0] }

    if ($masOutdated.Count -gt 0) {
        Write-Color "🛍️ Checking for Mac App Store updates..." -Color Yellow

        foreach ($app in $masOutdated) {
            # Skip Xcode (ID: 640199958)
            if ($app -eq "640199958") {
                Write-Color "Skipping Xcode update - it needs to be manually updated or in another account" -Color DarkYellow
                continue
            }

            # Try to update each app
            try {
                mas upgrade $app
            }
            catch {
                Write-Output "⚠️ Failed to update app with ID $app. It may not be installed."
            }
        }
    }
    else {
        Write-Color "✅ No Mac App Store updates available." -Color Green
    }
}

# Update Linux APT packages
# Usage: update_linux_apt
function update_linux_apt {
    Write-Color "🐧 Updating Linux packages..." -Color Yellow

    if (verify_commands "apt") {
        Write-Output "--------------------------------"
        Write-Output ""
        Write-Output "📦 Updating APT packages..."
        sudo apt update
        sudo apt upgrade -y
    }
}

# Check for Linux Snap updates
# Usage: update_linux_snap
function update_linux_snap {
    if (verify_commands "snap") {
        Write-Output "--------------------------------"
        Write-Output ""
        Write-Color "🔄 Checking for Snap updates..." -Color Yellow
        sudo snap refresh --list
    }
}

# Update Linux Flatpak packages
# Usage: update_linux_flatpak
function update_linux_flatpak {
    if (verify_commands "flatpak") {
        Write-Output "--------------------------------"
        Write-Output ""
        Write-Color "📦 Updating Flatpak packages..." -Color Yellow
        flatpak update -y
    }
}

# Update Homebrew packages
# Usage: update_homebrew
function update_homebrew {
    if (verify_commands "brew") {
        Write-Output "--------------------------------"
        Write-Output ""
        Write-Color "🍺 Updating Homebrew packages..." -Color Yellow
        brew update
        brew upgrade
        brew upgrade --cask --greedy
        brew cleanup
    }

    if (verify_commands "code") {
        code tunnel restart
    }
}

# Remove older versions of each major .NET SDK version (keep only latest)
# Usage: remove_dotnet_older_versions
function remove_dotnet_older_versions {
    if (-not (verify_commands "dotnet")) {
        return
    }

    Write-Output "--------------------------------"
    Write-Color "🧹 Cleaning up older .NET SDK versions..." -Color Yellow

    # Get all installed SDKs
    $sdks = dotnet --list-sdks | ForEach-Object {
        ($_ -split '\s+')[0]
    }

    # Group by major version
    $majorVersions = @{}
    foreach ($sdk in $sdks) {
        $major = $sdk.Split('.')[0]
        if (-not $majorVersions.ContainsKey($major)) {
            $majorVersions[$major] = @()
        }
        $majorVersions[$major] += $sdk
    }

    # For each major version, keep only the newest
    foreach ($major in $majorVersions.Keys) {
        $versions = $majorVersions[$major] | Sort-Object { [version]$_ }
        $toRemove = $versions[0..($versions.Count - 2)]

        foreach ($version in $toRemove) {
            Write-Color "  Removing .NET SDK $version" -Color DarkYellow
            $sdkPath = Join-Path $ENV:DOTNET_ROOT "sdk\$version"
            if (Test-Path $sdkPath) {
                Remove-Item -Recurse -Force $sdkPath
            }
        }

        if ($toRemove.Count -gt 0) {
            Write-Color "  Keeping .NET SDK $($versions[-1]) (latest for v$major)" -Color Green
        }
    }

    Write-Color "✅ .NET SDK cleanup completed" -Color Green
}

# Update .NET SDK versions (6.0, 7.0, 8.0, 9.0)
# Usage: update_dotnet_versions
function update_dotnet_versions {
    if (-not (verify_commands "dotnet")) {
        return
    }

    # Check if dotnet-install script exists
    $downloadsFolder = Join-Path $ENV:USERPROFILE "Downloads"
    $dotnetInstaller = Join-Path $downloadsFolder "dotnet-install.ps1"

    if (-not (Test-Path $dotnetInstaller)) {
        Write-Color "Downloading dotnet-install.ps1..." -Color Yellow
        Invoke-WebRequest -Uri "https://dot.net/v1/dotnet-install.ps1" -OutFile $dotnetInstaller
    }

    Write-Output "--------------------------------"
    Write-Output ""
    Write-Color "🟣️ Updating Dotnet SDKs..." -Color Yellow

    & $dotnetInstaller -Channel 9.0 -InstallDir $ENV:DOTNET_ROOT
    & $dotnetInstaller -Channel 8.0 -InstallDir $ENV:DOTNET_ROOT
    & $dotnetInstaller -Channel 7.0 -InstallDir $ENV:DOTNET_ROOT
    & $dotnetInstaller -Channel 6.0 -InstallDir $ENV:DOTNET_ROOT

    remove_dotnet_older_versions
}