if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Loading Functions'
}

function reload {
    . $PROFILE
}

## OS Functions
function IsWindows() {
    return $PSVersionTable.Platform.StartsWith("Win")
}

function IsLinux() {
    return $PSVersionTable.Platform.StartsWith("Linux")
}

function IsOsx() {
    return $PSVersionTable.Platform.StartsWith("Linux")
}

function c { Clear-Host }

### Navigate path
if (!(Get-Command "zoxide" -ErrorAction SilentlyContinue)) {
    function z {
        # Verifiy if $args is empty
        if (-not $args) {
            Set-Location $HOME
        }
        else {
            # Verify if $args is a valid path
            if (Test-Path -Path $args[0] -PathType Container) {
                # Verify if $args first arg is a directory
                try {
                    if ($args.Count -gt 1) {
                        if ($args -Contains "-PassThru") {
                            Set-Location -Path $args[0] -PassThru
                        }
                        else {
                            Set-Location -Path $args[0] $args[1..$args.Count]
                        }
                    }
                    else {
                        Set-Location $args[0]
                    }

                    # Verify if the current directory contains a .git folder
                    if (Get-Command "git" -ErrorAction SilentlyContinue) {
                        if (Test-Path ".git") {
                            # Write-Host "Git repository found"
                            try {
                                git pull > $null
                                git fetch --all --prune > $null
                                Write-Host "---------------------------------------------"
                                git status
                                Write-Host "---------------------------------------------"
                                Write-Host "  "
                                onefetch --number-of-authors 5 -d head -d license -d churn --no-title
                                Write-Host "  "
                            }
                            catch {
                            }
                        }
                    }
                }
                catch {
                    Write-Host "Error: $args"
                    Write-Host $_
                }
            }
            else {
                Write-Host "$args is not a directory or doesn't exists"
            }
        }
    }
    Set-Alias -Name cd -Value z -Option AllScope

    function back { z -Path - }
    function .. { z .. }
    function ... { z ..\.. }
    function .... { z ..\..\.. }
    function ..... { z ..\..\..\.. }
} else {
    function .. { cd .. }
    function ... { cd ..\.. }
    function .... { cd ..\..\.. }
    function ..... { cd ..\..\..\.. }
}


### Program Tools Specific Functions
if (Get-Command "python" -ErrorAction SilentlyContinue) {
    function pip { python -m pip $args }
}

if (Get-Command "git" -ErrorAction SilentlyContinue) {
    function gs { git status }
}

if (Get-Command "dotnet" -ErrorAction SilentlyContinue) {
    function nugetadd ([Parameter(ValueFromRemainingArguments = $true)][string[]]$packages) {
        Foreach ($package in $packages) {
            dotnet add package $package
        }
    }
}


### Print Functions
function path {
    $Env:PATH -split ";"
}

function env {
    Get-ChildItem env:
}


### Write Host Functions
function CenterText {
    param($Message)
    return ("{0}{1}" -f (' ' * (([Math]::Max(0, $Host.UI.RawUI.BufferSize.Width / 2) - [Math]::Floor($Message.Length / 2)))), $Message)
}

function Write-Err {
    Param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$message
    )
    Write-Host "----------------------------------------"
    Write-Color $message -Color Red
    Write-Host "----------------------------------------"
}

function Write-Title {
    Param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$message
    )
    Write-Host "----------------------------------------"
    Write-Color $message -Color Green
    Write-Host "----------------------------------------"
}

function lsb_release {
    if (Get-Command "winfetch" -ErrorAction SilentlyContinue) { winfetch }
    else { Write-Host "Try: scoop install winfetch" }
}

function Show-Notification {
    [cmdletbinding()]
    Param (
        [string]
        $ToastTitle,
        [string]
        [parameter(ValueFromPipeline)]
        $ToastText,
        [string]
        $IconPath = "C:/Users/julia/OneDrive - Sol Agora/Imagens/Icones/ultron.jpg"
    )

    if (Get-Module -ListAvailable -Name BurntToast) {
        $icon_path = $PSCmdlet.MyInvocation.BoundParameters['IconPath'] -or "C:/Users/julia/OneDrive - Sol Agora/Imagens/Icones/ultron.jpg"
        if (Test-Path $icon_path) {
            New-BurntToastNotification -AppLogo $icon_path -Text $ToastTitle, $ToastText
        }
        else {
            New-BurntToastNotification -Text $ToastTitle, $ToastText
        }
    }
    else {
        Write-Err $ToastText
    }
}

function AmIAdmin() {
    if ($IsLinux) { return $false }
    if ($IsMacOS) { return $false }
    
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

function resetWSL {
    & net stop LxssManager
    & taskkill /f /im 'Docker Desktop.exe'
    & taskkill /f /im wslservice.exe
    & net start LxssManager
    & wsl --shutdown Ubuntu
    & wsl --shutdown docker-desktop
    & wsl --shutdown docker-desktop-data
}

function wslReset {
    resetWSL
}


### Tools
function kill { Stop-Process -Force -Id $args }
function work {
    Param(
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$job
    )
    Write-Title "Work time! 💪🍅 $job"
    $totalMinutes = 50
    $totalSeconds = $totalMinutes * 60
    $totalMilliseconds = $totalSeconds * 1000
    $waitMilliseconds = $totalMilliseconds / 100

    $start = (Get-Date).ToLongTimeString()
    $final = (Get-Date).AddMilliseconds($totalMilliseconds).ToLongTimeString()
    $activityName = $null
    if ($job) { $activityName = $job } else { $activityName = "Pomodoro" }

    for ($i = 1; $i -le 100; $i++ ) {
        $waited = $waitMilliseconds * $i
        $completed = (($waitMilliseconds * $i) / $totalMilliseconds) * 100
        
        Write-Progress -Activity $activityName -Status "$start - $((Get-Date).ToLongTimeString()) - $final" -PercentComplete $completed
        Write-Host $completed "waited" $waited
        Start-Sleep -Milliseconds $waitMilliseconds
    }
    Show-Notification "Time's up" "Work Timer is up! Take a Break 😊"
}

function rest {
    Param(
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$job
    )
    Write-Title "Rest time! ☕🍵 $job"
    $totalMinutes = 10
    $totalSeconds = $totalMinutes * 60
    $totalMilliseconds = $totalSeconds * 1000
    $waitMilliseconds = $totalMilliseconds / 100
    $activityName = $null
    if ($job) { $activityName = $job } else { $activityName = "Resting" }

    $start = (Get-Date).ToLongTimeString()
    $final = (Get-Date).AddMilliseconds($totalMilliseconds).ToLongTimeString()

    for ($i = 1; $i -le 100; $i++ ) {
        $waited = $waitMilliseconds * $i
        $completed = (($waitMilliseconds * $i) / $totalMilliseconds) * 100
        Write-Progress -Activity $activityName -Status "$start - $((Get-Date).ToLongTimeString()) - $final" -PercentComplete $completed
        Write-Host $completed "waited" $waited
        Start-Sleep -Milliseconds $waitMilliseconds
    }

    Show-Notification "Break is Over" "Break is over! Get back to work 😬" 
}

function mkd {
    Param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$path
    )

    New-Item -ItemType Directory -Path $path
    Set-Location $path
}

function touch {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (Test-Path -LiteralPath $Path) {
        (Get-Item -Path $Path).LastWriteTime = Get-Date
    }
    else {
        New-Item -Type File -Path $Path
    }
}

function hide {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (Test-Path -LiteralPath $Path) {
    (Get-Item -Path $Path).Attributes += 'Hidden'
    }
    else {
        Write-Output $Path "doesn't exits" 
    }
}


function Set-DottedHidden {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = (Get-Location).Path
        ,
        [Parameter(Mandatory = $false, Position = 1)]
        [bool]$recursive = $false
    )

    # Get All items that starts with a dot 
    if ($recursive) {
        $items = Get-ChildItem $Path -Recurse | Where-Object { 
            $_.Name.StartsWith(".")
        }
    }
    else {
        $items = Get-ChildItem $Path | Where-Object { 
            $_.Name.StartsWith(".")
        }
    }

    # Loop through each item and set the Hidden Attribute 
    foreach ($item in $items) {
        # Write-Host "Setting Hidden attribute for $($item.FullName)"
        # Write-Host "Setting Hidden attribute for $($item.FullName)"
        Write-Color "Setting Hidden attribute for ", $item.FullName -Color White, Green

        # Combine the existing attributes with the Hidden attribute
        $item.Attributes = $item.Attributes -bor [System.IO.FileAttributes]::Hidden
    }
}

function quit {
    Exit
    $ps_pid = $ps_pid = (Get-Process -Id $PID).Id
    Stop-Process -Id $ps_pid -Force
}



function server {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [int]
        $Port = 1982
    )

    # if not port is specified, use 1982
    if ($null -eq $Port) {
        $Port = 1982
    }

    # start the server
    Write-Color "Starting server on port ", $Port -Color Yellow, Red
    python -m http.server $Port
}