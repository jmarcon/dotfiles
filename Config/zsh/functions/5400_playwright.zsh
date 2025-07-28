#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5400] - Playwright automation' 'yellow'


verify_commands playwright || return 1

# Current working directory
CURRENT_DIR="$(pwd)"

# Additional file information
SCRIPT_FILENAME="$(basename "$0")"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AUTOMATION_FOLDER="$SCRIPT_DIR/automation"
ALLOWED_ENVIRONMENTS=("local","dev","hom","plat","prod","root","sand","sec")

function validate_environment() {
    local env_name=$1
    if [[ -z "$env_name" ]]; then 
        echo "Error: Environment name is required"
        echo "Allowed: ${allowed_envs[*]}"
        return 1
    fi

    if [[ ! "${ALLOWED_ENVIRONMENTS[@]}" =~ "${env_name}" ]]; then
        echo "Error: Invalid environemnt - $env_name"
        echo "Allowed: ${ALLOWED_ENVIRONMENTS[*]}"
        return 1
    fi

    return 0
}


function authenticate_aws() {
    local env_name=$1
    validate_environment "$env_name" || return 1

    if [[ "$env_name" == "local" ]]; then 
        return 0
    fi

    print_color "Trying to authenticate in the $env_name environment" "yellow"
    aws_env_vars=$(uv run --script  "$AUTOMATION_FOLDER/get_env_vars.py" "$env_name")
    # Split output into lines and export variables
    lines=("${(f)aws_env_vars}")

    # Verify we have all needed values
    if [[ ${#lines[@]} -lt 5 ]]; then
        print_color "Invalid output from authentication script" "red"
        return 1
    fi

    export AWS_ACCESS_KEY_ID="${lines[1]}"
    export AWS_SECRET_ACCESS_KEY="${lines[2]}"
    export AWS_SESSION_TOKEN="${lines[3]}"
    export AWS_DEFAULT_REGION="${lines[4]}"
    export AWS_SELECTED_ACCOUNT="${lines[5]}"

    print_color "Authenticated to account: ${lines[5]}" "green"
    return 0
}

function __set_kubectl_context() {
    local env_name=$1
    
    if verify_commands kubectl; then
        alias k="kubectl --context=$env_name"
    fi
}

function __set_helm_context() {
    local env_name=$1
    
    if verify_commands helm; then
        export HELM_KUBECONTEXT=$env_name
        alias h="helm --kube-context=$env_name"
    fi
}

function __set_k9s_context() {
    local env_name=$1

    if verify_commands k9s; then
        alias k9s="k9s --context=$env_name"
    fi
}


function set_kubernetes_context() {
    local env_name=$1
    validate_environment "$env_name" || return 1
    
    print_color "Changing the kubernetes context for environment $env_name" "blue"

    case "$env_name" in
        "dev")
            notify "Selecting Development Kubernetes Context"
            # k ctx sol_dev
            __set_kubectl_context "sol_dev"
            __set_helm_context "sol_dev"
            __set_k9s_context "sol_dev"
            ;;
        "hom")
            notify "Selecting Homologation Kubernetes Context"
            # k ctx sol_hom
            __set_kubectl_context "sol_hom"
            __set_helm_context "sol_hom"
            __set_k9s_context "sol_hom"
            ;;
        "prod")
            notify "Selecting Production Kubernetes Context"
            # k ctx sol_prd
            __set_kubectl_context "sol_prd"
            __set_helm_context "sol_prd"
            __set_k9s_context "sol_prd"
            ;;
        *)
            notify "Selecting Local Kubernetes Context (Orbstack)"
            # k ctx docker-desktop
            __set_kubectl_context "orbstack"
            __set_helm_context "orbstack"
            __set_k9s_context "orbstack"
            ;;
    esac

}

function set_env() {
    local env_name=$1
    local env_type=$2

    validate_environment "$env_name" || return 1

    if [[ "$env_type" == "--no-auth" ]]; then
        set_kubernetes_context "$env_name"
        return 0
    fi

    authenticate_aws "$env_name"
    set_kubernetes_context "$env_name"
    return 0
}