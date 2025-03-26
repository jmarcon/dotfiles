# Install WSL
wsl --install -d "Ubuntu-24.04"

# Install python versions
if(Get-Command uv -ErrorAction SilentlyContinue) {
    uv python install 3.9
    uv python install 3.10
    uv python install 3.11
    uv python install 3.12
    uv python install 3.13
}

# Install node versions
if(Get-Command nvm -ErrorAction SilentlyContinue) {
    nvm install latest
    nvm install lts
    nvm install 18
    nvm install 20
    nvm install 21
    nvm install 22

    nvm use latest
}

# Install dotnet SDK
$dotnet_sdk_versions = @(
    "Microsoft.DotNet.SDK.8"
    "Microsoft.DotNet.SDK.6"
    "Microsoft.DotNet.SDK.Preview"
)

foreach ($version in $dotnet_sdk_versions) {
    winget install $version `
        -h `
        --accept-source-agreements `
        --accept-package-agreements `
        --disable-interactivity `
        --nowarn `
        --force
}
