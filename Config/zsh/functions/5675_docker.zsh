#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5675] - Docker Functions' 'yellow'

verify_commands docker || return 1

function ldocker() {
    local fpath="${1:-$(pwd)/Dockerfile}"

    if [[ ! -f "$fpath" ]]; then
        print_color "Dockerfile not found: $fpath" "red"
        return 1
    fi 

    docker run --rm -i -v "$fpath":"$fpath" --platform linux/amd64 hadolint/hadolint:latest hadolint "$fpath"
}

function gitleaks() {
    local repo_path="${1:-$(pwd)}"
    docker run --rm -v "$repo_path":"$repo_path" zricethezav/gitleaks:latest dir "$repo_path" -v
}
