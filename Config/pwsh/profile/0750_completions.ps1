if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Loading Powershell completions'
}

if (Get-Command "kops" -ErrorAction SilentlyContinue) { 
    kops completion powershell | Out-String | Invoke-Expression
}

if (Get-Command "sfsu" -ErrorAction SilentlyContinue) {
    Invoke-Expression (&sfsu hook)
}

if (Get-Command "zoxide" -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}