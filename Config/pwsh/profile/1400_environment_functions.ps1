DEBUG_WRITE 'Loading Environment Functions'

###############################################################################
# ENVIRONMENT AND KUBERNETES FUNCTIONS
# Ported from ZSH for cross-platform consistency
###############################################################################

# Allowed environment names
$script:ALLOWED_ENVIRONMENTS = @("local", "dev", "hom", "plat", "prod", "root", "sand", "sec")

# Validate environment name against allowed list
# Usage: validate_environment "dev"
function validate_environment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$EnvironmentName
    )

    if ([string]::IsNullOrWhiteSpace($EnvironmentName)) {
        Write-Host "Error: Environment name is required" -ForegroundColor Red
        Write-Host "Allowed: $($script:ALLOWED_ENVIRONMENTS -join ', ')" -ForegroundColor Yellow
        return $false
    }

    if ($script:ALLOWED_ENVIRONMENTS -notcontains $EnvironmentName) {
        Write-Host "Error: Invalid environment - $EnvironmentName" -ForegroundColor Red
        Write-Host "Allowed: $($script:ALLOWED_ENVIRONMENTS -join ', ')" -ForegroundColor Yellow
        return $false
    }

    return $true
}

# Authenticate to AWS for specified environment
# Usage: authenticate_aws "dev"
function authenticate_aws {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$EnvironmentName
    )

    if (-not (validate_environment $EnvironmentName)) {
        return $false
    }

    if ($EnvironmentName -eq "local") {
        return $true
    }

    Write-Color "Trying to authenticate in the $EnvironmentName environment" -Color Yellow

    # Note: This requires the Python automation script to be available
    # Adjust the path as needed for your setup
    $scriptDir = Split-Path $PSScriptRoot -Parent
    $automationFolder = Join-Path $scriptDir "automation"
    $scriptPath = Join-Path $automationFolder "get_env_vars.py"

    if (-not (Test-Path $scriptPath)) {
        Write-Color "Automation script not found: $scriptPath" -Color Red
        return $false
    }

    try {
        $awsEnvVars = uv run --script $scriptPath $EnvironmentName

        if (-not $awsEnvVars) {
            Write-Color "Invalid output from authentication script" -Color Red
            return $false
        }

        $lines = $awsEnvVars -split "`n"

        if ($lines.Count -lt 5) {
            Write-Color "Invalid output from authentication script" -Color Red
            return $false
        }

        $ENV:AWS_ACCESS_KEY_ID = $lines[1]
        $ENV:AWS_SECRET_ACCESS_KEY = $lines[2]
        $ENV:AWS_SESSION_TOKEN = $lines[3]
        $ENV:AWS_DEFAULT_REGION = $lines[4]
        $ENV:AWS_SELECTED_ACCOUNT = $lines[5]

        Write-Color "Authenticated to account: $($lines[5])" -Color Green
        return $true
    }
    catch {
        Write-Color "Error authenticating: $($_.Exception.Message)" -Color Red
        return $false
    }
}

# Set kubectl context for environment
# Usage: __set_kubectl_context "sol_dev"
function __set_kubectl_context {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ContextName
    )
}

# Set Helm context for environment
# Usage: __set_helm_context "sol_dev"
function __set_helm_context {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ContextName
    )

    if (verify_commands "helm") {
        $ENV:HELM_KUBECONTEXT = $ContextName
        Set-Alias -Name h -Value "helm --kube-context=$ContextName" -Scope Global
    }
}

# Set k9s context for environment
# Usage: __set_k9s_context "sol_dev"
function __set_k9s_context {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ContextName
    )

    if (verify_commands "k9s") {
        # Set-Alias -Name k9s -Value "$k9s_path --context $ContextName" -Scope Global
    }
}

# Set Kubernetes context based on environment
# Usage: set_kubernetes_context "dev"
function set_kubernetes_context {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$EnvironmentName
    )

    if (-not (validate_environment $EnvironmentName)) {
        return $false
    }

    Write-Color "Changing the kubernetes context for environment $EnvironmentName" -Color Blue

    switch ($EnvironmentName) {
        "dev" {
            notify "Selecting Development Kubernetes Context"
            $ENV:ContextName = "sol_dev"
            __set_kubectl_context "sol_dev"
            __set_helm_context "sol_dev"
            __set_k9s_context "sol_dev"
        }
        "hom" {
            notify "Selecting Homologation Kubernetes Context"
            $ENV:ContextName = "sol_hom"
            __set_kubectl_context "sol_hom"
            __set_helm_context "sol_hom"
            __set_k9s_context "sol_hom"
        }
        "prod" {
            notify "Selecting Production Kubernetes Context"
            $ENV:ContextName = "sol_prd"
            __set_kubectl_context "sol_prd"
            __set_helm_context "sol_prd"
            __set_k9s_context "sol_prd"
        }
        "local" {
            notify "Selecting Local Kubernetes Context (Minikube)"
            $ENV:ContextName = "docker-desktop"
            __set_kubectl_context "docker-desktop"
            __set_helm_context "docker-desktop"
            __set_k9s_context "docker-desktop"
        }
        default {
            notify "Selecting Local Kubernetes Context (Orbstack)"
            $ENV:ContextName = "orbstack"
            __set_kubectl_context "orbstack"
            __set_helm_context "orbstack"
            __set_k9s_context "orbstack"
        }
    }

    return $true
}

# Set environment (authenticate AWS + set Kubernetes context)
# Usage: set_env "dev" or set_env "dev" "--no-auth"
function set_env {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$EnvironmentName,
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$Flag
    )

    if (-not (validate_environment $EnvironmentName)) {
        return $false
    }

    if ($Flag -eq "--no-auth") {
        set_kubernetes_context $EnvironmentName
        return $true
    }

    authenticate_aws $EnvironmentName
    set_kubernetes_context $EnvironmentName
    return $true
}

###############################################################################
# FILE AND DEPENDENCY MANAGEMENT FUNCTIONS
###############################################################################

# Remove dependencies with confirmation
# Usage: remove_deps "node_modules"
function remove_deps {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Pattern
    )

    $currentDir = Get-Location
    $items = Get-ChildItem -Path $currentDir -Recurse -Filter $Pattern -ErrorAction SilentlyContinue

    $count = 0
    foreach ($item in $items) {
        Write-Host "Found: $($item.FullName)" -ForegroundColor Yellow
        $response = Read-Host "Delete this item? (y/n)"

        if ($response -match '^[Yy]$') {
            if ($item.PSIsContainer) {
                Remove-Item -Recurse -Force $item.FullName
            }
            else {
                Remove-Item -Force $item.FullName
            }
            $count++
            Write-Host "Deleted: $($item.FullName)" -ForegroundColor Red
        }
        else {
            Write-Host "Skipped: $($item.FullName)" -ForegroundColor Gray
        }
    }

    return $count
}

# Clean dependency folders for multiple languages
# Usage: clean_deps or clean_deps "python" or clean_deps "nodejs"
function clean_deps {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$Language
    )

    $currentDir = Get-Location
    $count = 0
    $allDeps = $false

    # Define dependency patterns for each language
    $pythonDeps = @(".venv", "__pycache__", "*.pyc", "*.pyo", "*.egg-info", "dist", "build")
    $dotnetDeps = @("bin", "obj", ".vs", "packages", "*.user")
    $nodejsDeps = @("node_modules", "package-lock.json", "yarn.lock", "npm-debug.log")
    $javaDeps = @("target", "build", ".gradle", "*.class", "*.jar")
    $rubyDeps = @("vendor/bundle", ".bundle", "*.gem")
    $goDeps = @("vendor", "go.sum")
    $rustDeps = @("target", "Cargo.lock")

    # If no language specified, clean all
    if ([string]::IsNullOrWhiteSpace($Language)) {
        $allDeps = $true
        Write-Host "No language specified. Cleaning all dependency folders..." -ForegroundColor Cyan
    }
    else {
        Write-Host "Cleaning $Language dependency folders..." -ForegroundColor Cyan
    }

    # Clean Python dependencies
    if ($Language -eq "python" -or $allDeps) {
        Write-Host "`nScanning for Python dependencies..." -ForegroundColor Yellow
        foreach ($pattern in $pythonDeps) {
            $count += remove_deps $pattern
        }
    }

    # Clean .NET dependencies
    if ($Language -eq "dotnet" -or $allDeps) {
        Write-Host "`nScanning for .NET dependencies..." -ForegroundColor Yellow
        foreach ($pattern in $dotnetDeps) {
            $count += remove_deps $pattern
        }
    }

    # Clean Node.js dependencies
    if ($Language -eq "nodejs" -or $Language -eq "node" -or $allDeps) {
        Write-Host "`nScanning for Node.js dependencies..." -ForegroundColor Yellow
        foreach ($pattern in $nodejsDeps) {
            $count += remove_deps $pattern
        }
    }

    # Clean Java dependencies
    if ($Language -eq "java" -or $allDeps) {
        Write-Host "`nScanning for Java dependencies..." -ForegroundColor Yellow
        foreach ($pattern in $javaDeps) {
            $count += remove_deps $pattern
        }
    }

    # Clean Ruby dependencies
    if ($Language -eq "ruby" -or $allDeps) {
        Write-Host "`nScanning for Ruby dependencies..." -ForegroundColor Yellow
        foreach ($pattern in $rubyDeps) {
            $count += remove_deps $pattern
        }
    }

    # Clean Go dependencies
    if ($Language -eq "go" -or $allDeps) {
        Write-Host "`nScanning for Go dependencies..." -ForegroundColor Yellow
        foreach ($pattern in $goDeps) {
            $count += remove_deps $pattern
        }
    }

    # Clean Rust dependencies
    if ($Language -eq "rust" -or $allDeps) {
        Write-Host "`nScanning for Rust dependencies..." -ForegroundColor Yellow
        foreach ($pattern in $rustDeps) {
            $count += remove_deps $pattern
        }
    }

    Write-Host "`nCleaning complete. Removed $count dependency items." -ForegroundColor Green
}
