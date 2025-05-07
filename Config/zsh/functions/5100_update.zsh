#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5100] - Update' 'yellow'

function update() {
    # Detect OS if CURRENT_OS is not set
    local os_type="$CURRENT_OS"
    if [[ -z "$os_type" ]]; then
        case "$(uname -s)" in
        Darwin*) os_type="mac" ;;
        Linux*) os_type="linux" ;;
        *) os_type="unknown" ;;
        esac
    fi

    # Print which OS is being updated
    notify "🔄 Updating system packages for $os_type..."

    # Report versions of key tools before updating
    print_color "Current versions:" "cyan"
    command -v node >/dev/null 2>&1 && echo "Node: $(node -v)"
    command -v npm >/dev/null 2>&1 && echo "NPM: $(npm -v)"
    command -v python >/dev/null 2>&1 && echo "Python: $(python --version)"
    command -v go >/dev/null 2>&1 && echo "Go: $(go version)"
    command -v rustc >/dev/null 2>&1 && echo "Rust: $(rustc --version)"

    # Update based on detected OS
    case "$os_type" in
    "mac")
        # macOS specific updates
        if command -v softwareupdate >/dev/null 2>&1; then
            echo "📱 Checking for macOS updates..."
            softwareupdate --list
        fi
        ;;

    "linux")
        echo "🐧 Updating Linux packages..."
        # APT updates
        if command -v apt >/dev/null 2>&1; then
            echo "📦 Updating APT packages..."
            sudo apt update && sudo apt upgrade -y
        fi

        # Snap updates
        if command -v snap >/dev/null 2>&1; then
            echo "🔄 Checking for Snap updates..."
            sudo snap refresh --list
        fi

        # Flatpak updates
        if command -v flatpak >/dev/null 2>&1; then
            echo "📦 Updating Flatpak packages..."
            flatpak update -y
        fi
        ;;

    *)
        echo "⚠️ Unknown OS type: $os_type"
        ;;
    esac

    # Homebrew updates (works on both macOS and Linux)
    if command -v brew >/dev/null 2>&1; then
        echo "🍺 Updating Homebrew packages..."
        brew update
        brew upgrade
        brew upgrade --cask --greedy
        brew cleanup
    fi

    echo "✅ System update completed!"
}

# Shorthand aliases for the update function
alias upd='update'
alias up='update'
