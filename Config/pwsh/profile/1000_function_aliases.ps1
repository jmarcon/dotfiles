# Function aliases and wrappers to match ZSH naming conventions
# This file provides consistent function names across PowerShell and ZSH profiles
DEBUG_WRITE 'Loading Function Aliases'

# Wrapper for Show-Notification (defined in 1000_functions.ps1)
function notify {
    Show-Notification @args
}

# Wrapper for Write-Color (from PSWriteColor module)
function print_color {
    Write-Color @args
}

# Wrapper for Write-Title (defined in 1000_functions.ps1)
function show_title {
    Write-Title @args
}

# Wrapper for Add-Path (defined in 0100_path.ps1)
function add_in_path {
    Add-Path @args
}

# Wrapper for path function (defined in 1000_functions.ps1)
function print_path {
    path @args
}

# Wrapper for Git-UpdateAllRepositories (defined in 1200_git_functions.ps1)
function pull_all_repos {
    Git-UpdateAllRepositories @args
}

# Wrapper for k-ctx/kctx (defined in 1100_kubectl_functions.ps1)
function set_kubernetes_context {
    k-ctx @args
}

# Wrapper for k-kill-ns (force terminates namespaces stuck in "Terminating" state)
# This matches the ZSH kkns function behavior
function kkns {
    k-kill-ns @args
}
