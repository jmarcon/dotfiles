#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5500] - Git Functions' 'yellow'

if command -v git >/dev/null 2>&1; then
    function pull_all_repos() {
        local initial_dir=$(pwd)

        echo "Finding Git repositories recursively from $(pwd)..."

        # Find all .git directories, extract their parent directory, and run git pull
        find . -type d -name ".git" | while read gitdir; do
            repo_path=$(dirname "$gitdir")

            echo "\n📂 Repository: $repo_path"
            cd "$repo_path"

            # Check if remote exists
            if git remote -v | grep -q fetch; then
                # Get current branch
                current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
                echo "Current branch: $current_branch"

                # Check if branch is already main or master
                if [[ "$current_branch" != "main" && "$current_branch" != "master" ]]; then
                    echo "Not on main/master branch. Attempting to switch..."

                    # Fetch to get latest branch information
                    git fetch --all

                    # Check if main branch exists
                    if git show-ref --verify --quiet refs/heads/main; then
                        echo "Switching to main branch..."
                        git checkout main
                    # Check if master branch exists
                    elif git show-ref --verify --quiet refs/heads/master; then
                        echo "Switching to master branch..."
                        git checkout master
                    else
                        echo "Neither main nor master branch found. Staying on $current_branch."
                    fi
                fi

                # Now pull the current branch
                echo "Pulling latest changes..."
                git pull
            else
                echo "⚠️  No remote configured, skipping."
            fi

            cd "$initial_dir"
        done

        echo "\n✅ All repositories updated!"
    }
fi
