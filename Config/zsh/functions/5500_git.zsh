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

# Function to backup all git repositories with complete branch and change information
# Fetches all remote branches and ensures they exist locally
function backup_all_repos() {
    local initial_dir=$(pwd)

    echo "Starting full backup of Git repositories from $initial_dir...\n"

    # Find all .git directories and process each repository
    find . -type d -name ".git" | while read gitdir; do
        repo_path=$(dirname "$gitdir")

        echo "\n📂 Repository: $repo_path"
        cd "$repo_path"

        # Check if remote exists
        if ! git remote -v | grep -q fetch; then
            echo "⚠️  No remote configured, skipping."
            cd "$initial_dir"
            continue
        fi

        # Fetch all remotes
        echo "Fetching all remotes..."
        git fetch --all --tags --prune

        # Store current branch to restore later
        current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)

        # Get list of all remote branches
        echo "Processing remote branches..."
        git branch -r | grep -v '\->' | while read remote_branch; do
            # Extract branch name without remote prefix
            branch_name=$(echo "$remote_branch" | sed 's/.*\///')

            # Check if local branch exists
            if git show-ref --verify --quiet "refs/heads/$branch_name"; then
                echo "  ✓ Updating local branch: $branch_name"
                git checkout -q "$branch_name"
                git pull
            else
                echo "  + Creating and pulling local branch: $branch_name from $remote_branch"
                git checkout -b "$branch_name" "$remote_branch"
            fi
        done

        # Return to original branch if it exists
        if [[ -n "$current_branch" ]]; then
            echo "Returning to original branch: $current_branch"
            git checkout -q "$current_branch"
        fi

        # Report current status
        echo "\nRepository status:"
        echo "  Local branches:"
        git branch | sed 's/^/    /'

        echo "  Uncommitted changes:"
        if [[ -n $(git status --porcelain) ]]; then
            git status --short | sed 's/^/    /'
        else
            echo "    (none)"
        fi

        echo "  Tags:"
        local tag_count=$(git tag | wc -l | tr -d ' ')
        echo "    Total: $tag_count tags"

        cd "$initial_dir"
    done

    echo "\n✅ Backup complete!"
}

