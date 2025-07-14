#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5100] - Update' 'yellow'

function print_dotnet_versions() {
    if command -v dotnet >/dev/null 2>&1; then
        echo "Dotnet: $(dotnet --version)"
        echo "--------------------------------"
        echo "Dotnet Available SDKs"
        dotnet --list-sdks | awk '{print $1}' | sed 's/\[.*\]//' | awk '{print "  SDK: " $1}'

    fi
}

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
    
    print_dotnet_versions
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

function remove_dotnet_older_versions() {
    # It will remove older versions of each major version installed but the newest
    if command -v dotnet >/dev/null 2>&1; then
        echo "--------------------------------"
        print_color "🧹 Cleaning up older .NET SDK versions..." "yellow"
        
        # Get all installed SDKs and group by major version
        local sdks=($(dotnet --list-sdks | awk '{print $1}'))
        
        # Create associative array to track versions by major version
        declare -A major_versions
        
        # Group SDKs by major version
        for sdk in "${sdks[@]}"; do
            local major=$(echo $sdk | cut -d. -f1)
            if [[ -n "${major_versions[$major]}" ]]; then
                major_versions[$major]="${major_versions[$major]} $sdk"
            else
                major_versions[$major]="$sdk"
            fi
        done
        
        # For each major version, keep only the newest
        for major in "${(@k)major_versions}"; do
            local versions_array=(${=major_versions[$major]})
            
            # Sort versions and get all but the last (newest)
            local sorted_versions=($(printf '%s\n' "${versions_array[@]}" | sort -V))
            local versions_to_remove=(${sorted_versions[@]:0:$((${#sorted_versions[@]}-1))})
            
            # Remove older versions
            for version in "${versions_to_remove[@]}"; do
                print_color "  Removing .NET SDK $version" "orange"
                if [[ -d "$DOTNET_ROOT/sdk/$version" ]]; then
                    rm -rf "$DOTNET_ROOT/sdk/$version"
                fi
            done
            
            # Show what we're keeping
            if [[ ${#versions_to_remove[@]} -gt 0 ]]; then
                print_color "  Keeping .NET SDK ${sorted_versions[-1]} (latest for v$major)" "green"
            fi
        done
        
        print_color "✅ .NET SDK cleanup completed" "green"
    fi
}

function update_dotnet_versions() {
    if command -v dotnet >/dev/null 2>&1; then
        # if the file /Users/jm/Downloads/dotnet-install.sh does not exists, 
        # then return the function
        if [ ! -f /Users/jm/Downloads/dotnet-install.sh ]; then
            return
        fi

        /Users/jm/Downloads/dotnet-install.sh -c 9.0 -i $DOTNET_ROOT
        /Users/jm/Downloads/dotnet-install.sh -c 8.0 -i $DOTNET_ROOT
        /Users/jm/Downloads/dotnet-install.sh -c 7.0 -i $DOTNET_ROOT
        /Users/jm/Downloads/dotnet-install.sh -c 6.0 -i $DOTNET_ROOT

        remove_dotnet_older_versions
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
    update_dotnet_versions

    echo "--------------------------------"
    echo ""
    echo "✅ System update completed!"
}

# Shorthand aliases for the update function
alias upd='update'
alias up='update'
