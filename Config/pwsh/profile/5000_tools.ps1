if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Loading Tools'
}

if(Get-Command "dotnet" -ErrorAction SilentlyContinue) {
    function Dotnet-Update-Csproj-Dependencies {
        param (
            [Parameter(Mandatory = $false, Position = 0)]
            [string]$Path = (Get-Location).Path
        )

        $projects = $(Get-ChildItem -Path $Path -Filter "*.csproj" -Recurse)

        # If projects is empty, notting to do
        if ($projects.Count -eq 0) {
            Write-Host "No csproj files found in $Path"
            return
        }

        # Verify if dotnet is installed
        if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
            Write-Host "Dotnet is not installed. Please install it before running this command"
            return
        }

        # Verify if dotnet outdated tool is installed
        if (-not (Get-Command dotnet-outdated -ErrorAction SilentlyContinue)) {
            Write-Host "Dotnet outdated tool is not installed. Installing it..."
            dotnet tool install --global dotnet-outdated
        }

        $projects | ForEach-Object {
            $csproj = $_.FullName
            Write-Host "Updating dependencies for $csproj"
            # Try
            try {
                dotnet outdated $csproj -u -vl Major
            }
            catch {
                Write-Host "Error updating dependencies for $csproj"
            }
        }
    }
}

if(Get-Command "docker" -ErrorAction SilentlyContinue) {
    function hollywood {
        docker run --rm -it bcbcarl/hollywood
    }

    function caniuse {
        docker run -t --rm difro/caniuse-cmd $args
    }

    function ldocker {
        param (
            [Parameter(Mandatory = $false, Position = 0)]
            [string]$DockerFilePath = (Get-Location).Path + "\Dockerfile"
        )
        cat $DockerFilePath | docker run --rm -i hadolint/hadolint:latest-alpine
    }

    function gitleaks() {
        param(
            [Parameter(Mandatory = $false, Position = 0)]
            [string]$RepoPath = (Get-Location).Path
        )

        docker run --rm -v "$RepoPath`:/evaluated_directory" zricethezav/gitleaks:latest dir "/evaluated_directory" -v
    }
}

# VFOX
if(Get-Command "vfox" -ErrorAction SilentlyContinue) {
    Invoke-Expression "$(vfox activate pwsh)"
}
