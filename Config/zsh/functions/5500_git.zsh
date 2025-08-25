#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5500] - Git Functions' 'yellow'

verify_commands git || return 1

# Function to recursively find all git repositories and pull latest changes
# Automatically switches to main/master branch if not already on it
function pull_all_repos() {
    # Store initial directory to return to after processing all repos
    local initial_dir=$(pwd)

    echo "Finding Git repositories recursively from $initial_dir..."

    # Find all .git directories, extract their parent directory, and run git pull
    find . -type d -name ".git" | while read gitdir; do
        # Get the repository path by removing .git from the end
        repo_path=$(dirname "$gitdir")

        echo "\n📂 Repository: $repo_path"
        cd "$repo_path"

        # Check if remote exists before attempting operations
        if git remote -v | grep -q fetch; then
            # Get current branch name (handles detached HEAD gracefully)
            current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
            echo "Current branch: $current_branch"

            # Switch to main/master branch if not already on it
            if [[ "$current_branch" != "main" && "$current_branch" != "master" ]]; then
                echo "Not on main/master branch. Attempting to switch..."

                # Fetch latest remote information first
                git fetch --all

                # Try to switch to main branch first (modern default)
                if git show-ref --verify --quiet refs/heads/main; then
                    echo "Switching to main branch..."
                    git checkout main
                # Fall back to master branch if main doesn't exist
                elif git show-ref --verify --quiet refs/heads/master; then
                    echo "Switching to master branch..."
                    git checkout master
                # Fall back again to release branch if neither main nor master exists
                elif git show-ref --verify --quiet refs/heads/release; then
                    echo "Switching to release branch..."
                    git checkout release
                else
                    echo "Neither main nor master branch found. Staying on $current_branch."
                fi
            fi

            # Pull latest changes from the remote
            echo "Pulling latest changes..."
            git pull
        else
            echo "⚠️  No remote configured, skipping."
        fi

        # Return to initial directory for next iteration
        cd "$initial_dir"
    done

    echo "\n✅ All repositories updated!"
}
