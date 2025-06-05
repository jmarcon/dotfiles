#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5100] - Update' 'yellow'

function print_versions() {
    print_color "Current versions:" "cyan"
    echo "--------------------------------"
    command -v node >/dev/null 2>&1 && echo "Node: $(node -v)"
    command -v yarn >/dev/null 2>&1 && echo "Yarn: $(yarn -v)"
    command -v bun >/dev/null 2>&1 && echo "Bun: $(bun -v)"
    command -v npm >/dev/null 2>&1 && echo "NPM: $(npm -v)"

    command -v python >/dev/null 2>&1 && echo "Python: $(python --version)"
    command -v pyenv >/dev/null 2>&1 && echo "Pyenv: $(pyenv --version)"

    command -v go >/dev/null 2>&1 && echo "Go: $(go version)"
}

function update_python_pyenv() {
    if command -v pyenv >/dev/null 2>&1; then
        # Get the latest version of python from pyenv install --list
        local latest_version=$(pyenv install --list | grep -v 'dev' | grep -v 'a' | grep -v 't' | grep -v 'b' | grep -v 'rc' | grep -v 'p' | grep -v 'n' | tail -n 1)
        # Remove any spaces from the version
        latest_version=$(echo $latest_version | tr -d ' ')

        # Get latest version installed
        local installed_version=$(pyenv versions --bare | tail -n 1)

        if [[ $installed_version != $latest_version ]]; then
            echo "--------------------------------"
            echo ""
            print_color "Installing Python $latest_version" "yellow"
            pyenv install $latest_version
            pyenv global $latest_version
        fi
    fi
}

function update_node() {
    if command -v nvm >/dev/null 2>&1; then
        echo "--------------------------------"
        echo ""
        print_color "Updating Node.js" "yellow"
        nvm install node
        nvm use node
        nvm alias default node
    fi

    if command -v npm >/dev/null 2>&1; then
        echo "--------------------------------"
        echo ""
        print_color "Updating NPM" "yellow"
        npm install -g npm
        npm update -g
    fi
}

function update_macos() {
    if command -v softwareupdate >/dev/null 2>&1; then
        echo "--------------------------------"
        echo ""
        print_color "📦 Updating macOS..." "yellow"
        # Install all available updates
        softwareupdate --install --all --agree-to-license
    fi
}

function update_macos_apps() {
    if command -v mas >/dev/null 2>&1; then
        echo "--------------------------------"
        echo ""
        # Get mas outdated and put into a list of apps
        local mas_outdated
        mas_outdated=$(mas outdated | awk '{print $1}')
        
        # Convert mas_outdated to an array
        mas_outdated=(${=mas_outdated})

        # Check if there are any outdated apps
        if [[ -n "$mas_outdated" ]]; then
            print_color "🛍️ Checking for Mac App Store updates..." "yellow"
            # Update all outdated apps
            for app in $mas_outdated; do
                # If app is 640199958 (Xcode) then skip
                if [[ $app == 640199958 ]]; then
                    print_color "Skipping Xcode update - it needs to be manually updated or in another account" "orange"
                    continue
                fi

                # Try to update each app and handle errors
                if ! mas upgrade "$app"; then
                    echo "⚠️ Failed to update app with ID $app. It may not be installed."
                    continue
                fi
            done
        else
            print_color "✅ No Mac App Store updates available." "green"
        fi
    fi
}

function update_linux_apt() {
    print_color "🐧 Updating Linux packages..." "yellow"
    # APT updates
    if command -v apt >/dev/null 2>&1; then
        echo "--------------------------------"
        echo ""
        echo "📦 Updating APT packages..."
        sudo apt update && sudo apt upgrade -y
    fi
}

function update_linux_snap() {
    # Snap updates
    if command -v snap >/dev/null 2>&1; then
        echo "--------------------------------"
        echo ""
        print_color "🔄 Checking for Snap updates..." "yellow"
        sudo snap refresh --list
    fi
}

function update_linux_flatpak() {
    # Flatpak updates
    if command -v flatpak >/dev/null 2>&1; then
        echo "--------------------------------"
        echo ""
        print_color "📦 Updating Flatpak packages..." "yellow"
        flatpak update -y
    fi
}

function update_homebrew() {
    # Homebrew updates (works on both macOS and Linux)
    if command -v brew >/dev/null 2>&1; then
        echo "--------------------------------"
        echo ""
        print_color "🍺 Updating Homebrew packages..." "yellow"
        brew update
        brew upgrade
        brew upgrade --cask --greedy
        brew cleanup
    fi

    if command -v code >/dev/null 2>&1; then
        code tunnel restart
    fi
}

function update_nvim_lazy() {
    if command -v nvim >/dev/null 2>&1; then
        echo "--------------------------------"
        print_color "🔌 Updating Neovim (lazy.nvim) plugins..." "yellow"
        nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            print_color "❌ Failed to update Neovim (lazy.nvim) plugins!" "red"
        fi
    fi
}


function update() {
    # Detect OS if CURRENT_OS is not set
    local os_type="$CURRENT_OS"
    if [[ -z "$os_type" ]]; then
    case "$(uname -s)" in
        Darwin*) 
            os_type="mac" 
            ;;
        Linux*) 
            os_type="linux" 
            ;;
        *) 
            os_type="unknown"
            ;;
    esac
    fi

    # Print which OS is being updated
    notify "🔄 Updating system packages for $os_type..."

    # Report versions of key tools before updating
    print_versions

    # Update based on detected OS
    case "$os_type" in
    "mac")
        # macOS specific updates
        update_macos
        update_macos_apps
        ;;

    "linux")
        update_linux_apt
        update_linux_snap
        update_linux_flatpak
        ;;

    *)
        echo "⚠️ Unknown OS type: $os_type"
        ;;
    esac
    
    update_homebrew
    update_python_pyenv
    update_node
    update_nvim_lazy

    echo "--------------------------------"
    echo ""
    echo "✅ System update completed!"
}

# Shorthand aliases for the update function
alias upd='update'
alias up='update'
