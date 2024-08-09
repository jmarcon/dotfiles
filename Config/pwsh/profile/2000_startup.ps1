if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Starting Up'
}

if (AmIAdmin) {
    $txt = " "
    Write-Host $txt -ForegroundColor white
    $txt = CenterText "😱 😱 😱 😱 😱 😱 😱 😱 😱 😱 😱 😱 😱"
    Write-Host $txt -ForegroundColor red
    Write-Host " " -ForegroundColor white
    $txt = CenterText "You are running your terminal as"
    Write-Host $txt -ForegroundColor darkmagenta
    Write-Host " "
    $txt = CenterText "user ($Env:Username)"
    Write-Host $txt -ForegroundColor yellow
    $txt = CenterText "with Administrator access"
    Write-Host $txt -ForegroundColor red
    Write-Host " "
    $txt = CenterText "😱 😱 😱 😱 😱 😱 😱 😱 😱 😱 😱 😱 😱"
    Write-Host $txt
    Write-Host " "
}
else {
    # $joke = Invoke-RestMethod -Uri "https://api.chucknorris.io/jokes/random" -Method Get
    # cowsay $joke.value
    # Write-Host " "
}
