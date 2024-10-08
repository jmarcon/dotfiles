$winget_packages = @(
    "Docker.DockerDesktop"
    "JetBrains.Toolbox"
    "RedHat.Podman-Desktop"
    "Google.Chrome"
    "Nvidia.Broadcast"
    "MartiCliment.UniGetUI"
)

foreach ($package in $winget_packages) {
    winget install $package `
        -h `
        --accept-source-agreements `
        --accept-package-agreements `
        --disable-interactivity `
        --nowarn `
        --force
}
