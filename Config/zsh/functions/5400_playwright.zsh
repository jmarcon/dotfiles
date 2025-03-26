#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5400] - Playwright automation' 'yellow'


check_command() {
    if ! command -v $1 &> /dev/null; then
        echo "Error: $1 required"
        exit 1
    fi
}

check_command "playwright"

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

    echo "Trying to authenticate in the $env_name environment"
    aws_env_vars=$(uv run "$AUTOMATION_FOLDER/get_env_vars.py" "$env_name")
    lines=("${(f)aws_env_vars}")

    export AWS_ACCESS_KEY_ID="${lines[1]}"
    export AWS_SECRET_ACCESS_KEY="${lines[2]}"
    export AWS_SESSION_TOKEN="${lines[3]}"
    export AWS_DEFAULT_REGION="${lines[4]}"
    export AWS_SELECTED_ACCOUNT="${lines[5]}"

    echo "Authenticated Account: ${lines[5]}"
}

function set_kubernetes_context() {
    local env_name=$1
    validate_environment "$env_name" || return 1
    
    echo "Changing the kubernetes context for environment $env_name"

    case "$env_name" in
        "dev")
            echo "Selecting Development Kubernetes Context"
            k ctx sol_dev
            ;;
        "hom")
            echo "Selecting Homologation Kubernetes Context"
            k ctx sol_hom
            ;;
        "prod")
            echo "Selecting Production Kubernetes Context"
            k ctx sol_prd
            ;;
        *)
            echo "Selecting Docker-Compose Kubernetes Context"
            k ctx docker-desktop
            ;;
    esac

}

function set_env() {
    local env_name=$1
    validate_environment "$env_name" || return 1

    authenticate_aws "$env_name"
    set_kubernetes_context "$env_name"
}