if (!(Get-Command "kubectl" -ErrorAction SilentlyContinue)) { exit }

if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Loading Kubectl Functions'
}

function k { 
    kubectl $args 
}

function kgp { kubectl get pods -A $args }
function kgs { kubectl get svc -A $args }

function kns {
    Param(
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$namespace
    )

    if ($namespace) {
        kubectl config set-context --current --namespace=$namespace
    }
    else {
        kubectl config get-contexts | ForEach-Object {
            $ctx = ($_ -split "\s+")[1]
            if ($_ -match "NAME") {}
            elseif ($_ -match "\*") {
                Write-Host "* $ctx : Current"
            }
            else {
                Write-Host "- $ctx"
            }
        }
    }
}

function k-ctx {
    Param(
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$context
    )

    if ($context) {
        kubectl config use-context $context
    }
    else {
        if (Get-Command "ocgv" -ErrorAction SilentlyContinue) {
            $selected = $(kubectl config get-contexts --no-headers=true | ForEach-Object { ($_ -split "\s+")[1] } | ocgv -OutputMode Single)
        }
        else {
            $selected = $(kubectl config get-contexts --no-headers=true | ForEach-Object { ($_ -split "\s+")[1] } | Out-GridView -OutputMode Single)
        }
        kubectl config use-context $selected
    }
}

function k-kill { 
    ## for p in $(kubectl get pods | grep Terminating | awk '{print $1}'); do kubectl delete pod $p --grace-period=0 --force;done
    kubectl get pods | ForEach-Object {
        if ($_ -match "Terminating") {
            $pod = ($_ -split "\s+")[0]
            kubectl delete pod $pod --grace-period=0 --force
        }
    }
}

function kubeapps {
    $ka_token = [Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($(kubectl get --namespace default secret kubeapps-operator-token -o jsonpath='{.data.token}')))
    $ka_token | Set-Clipboard
    Write-Host "Use the token below to login to the Kubeapps dashboard (already copied to clipboard):"
    Write-Host $ka_token

    Start-Process "http://localhost:8080"
    & kubectl port-forward --namespace kubeapps svc/kubeapps 8080:80
}


# Function to Start or Stop Kubernetes Pods from Podman
function k8s {
    Param(
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$action
    )

    if ($isOsx) {
        Write-Title "This functionality is only for Windows"
        return
    }

    ## If docker not installed return
    if (-not(Get-Command "docker" -ErrorAction SilentlyContinue)) {
        Write-Title "docker not installed"
        return
    }

    ## If kind not installed return
    if (-not(Get-Command "kind" -ErrorAction SilentlyContinue)) {
        Write-Title "kind not installed"
        return
    }

    if ($action -ieq "status") {
        Write-Title "Status of k8s (kind)"
        if (-not (Get-Process com.docker.backend -ErrorAction SilentlyContinue)) {
            Write-Color "Docker", "	is not running" -Color Yellow, Red
            Write-Host "----------------------------------------"
            Write-Color "Your K8s cluster is not healthy  😢" -Color Red
            return
        }

        ## Local variable         
        $k8s_pods_healthy = $true
        $pods = docker ps -a | rg "kind-" | ForEach-Object { 
            $pod_name = $_.Split(" ")[-1] 
            $pod_name_clean = $pod_name.Trim()
            # Format pod name with fixed length
            $pod_name = $pod_name_clean.PadRight(20)
            Write-Host $pod_name
            Write-Host $pod_name_clean 
            $pod_status = docker inspect "$pod_name_clean" | jq '.[].State.Status' -r
            Write-Host "docker inspect $pod_name_clean | jq '.[].State.Status' -r     [$pods_status]"
            $pod_status = $pod_status.Status

            if ($pod_status -ieq "running") {
                $k8s_pods_healthy = $true
                # Write-Color "📦 Pod: ", $pod_name , " | Status: " , $pod_status , " | " , $k8s_pods_healthy -Color White, Yellow, White, Green, Black, Black
                Write-Title "📦 Pod: ", $pod_name, " ", $pod_status
            }
            elseif ($pod_status -ieq "exited") {
                $k8s_pods_healthy = $false
                # Write-Color "📦 Pod: ", $pod_name, " | Status: ", $pod_status, " | ", $k8s_pods_healthy -Color White, Yellow, White, Red, Black, Black
                Write-Title "📦 Pod: ", $pod_name, " ", $pod_status
            }
            elseif ($pod_status -ieq "created") {
                $k8s_pods_healthy = $false
                # Write-Color "📦 Pod: ", $pod_name, " | Status: ", $pod_status, " | ", $k8s_pods_healthy -Color White, Yellow, White, Yellow, Black, Black
                Write-Title "📦 Pod: ", $pod_name, " ", $pod_status
            }
            elseif ($pod_status -ieq "paused") {
                $k8s_pods_healthy = $false
                # Write-Color "📦 Pod: ", $pod_name, " | Status: ", $pod_status, " | ", $k8s_pods_healthy -Color White, Yellow, White, Yellow, Black, Black
                Write-Title "📦 Pod: ", $pod_name, " ", $pod_status
            }
            else {
                $k8s_pods_healthy = $false
                # Write-Color "📦 Pod: ", $pod_name, " | Status: ", $pod_status, " | ", $k8s_pods_healthy -Color White, Red, White, Red, Black, Black
                Write-Title "📦 Pod: ", $pod_name, " ", $pod_status
            }
        }

        if ($k8s_pods_healthy) {
            Write-Host "----------------------------------------"
            Write-Color "Your K8s cluster looks healthy 😎" -Color Green
        }
        else {
            Write-Color "Your K8s cluster is not healthy 😢" -Color Red
        }
    }

    if ($action -ieq "start" -or $action -ieq "up") {
        ## Verify if Docker Desktop is running
        if (-not (Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue)) {
            Write-Title "Starting Docker Desktop"
            Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
            Start-Sleep -s 10
        }

        # List of Pods
        $pods = docker ps -a | rg "kind" | ForEach-Object { $_.Split(" ")[-1] }
        if ($null -eq $pods) {
            Write-Title "No pods found | Need to create Kind Cluster (default)"
            kind create cluster
            return
        }
        else {
            # Start each pod
            ## Reorder pods to start with control-plane (kind-control-plane) and worker (kind-worker, kind-worker2, ...)
            $pods = $pods | Sort-Object
            
            foreach ($p in $pods) {
                $formatted_pod_name = $p.Trim().PadRight(20)
                Write-Color "📦 Pod: ", $formatted_pod_name, " | Status", " starting..." -Color White, Yellow, White, Green
                docker start $p | Out-Null
                
            }
        }
    }
    
    if ($action -ieq "stop" -or $action -ieq "down") {
        Write-Title "Stopping Docker Processes"
        Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue | Stop-Process -Force
        Start-Sleep -s 2
        Get-Process com.docker.backend -ErrorAction SilentlyContinue | Stop-Process -Force
        Start-Sleep -s 2
    }
    
    if (-not $action) {
        Write-Title "No action specified"
        Write-Host " "
        Write-Host "Usage: k8s start|up|stop|down|status"
    }
}