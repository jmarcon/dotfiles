#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5500] - Git Flow Functions' 'yellow'

verify_commands git || return 1

function git_flow_track_all() { 
        git fetch --all
        # List all remote branches and filter for git flow branches
        # Assuming git flow branches are prefixed with feature/, bugfix/, release/, hotfix
        # Put each line into an array
        local feats bugs releases hotfixes 
        local remote_feats remote_bugs remote_releases remote_hotfixes
        local local_feats local_bugs local_releases local_hotfixes

        # Get local branches and filter for git flow patterns, removing prefixes and whitespaces
        local_feats=$(git branch | grep 'feature/' | sed 's|feature/||' | tr -d ' ')
        local_bugs=$(git branch | grep 'bugfix/' | sed 's|bugfix/||' | tr -d ' ')
        local_releases=$(git branch | grep 'release/' | sed 's|release/||' | tr -d ' ')
        local_hotfixes=$(git branch | grep 'hotfix/' | sed 's|hotfix/||' | tr -d ' ')

        # Get remote branches and filter for git flow patterns, removing prefixes and whitespaces
        remote_feats=$(git branch -r | grep 'origin/feature/' | sed 's|origin/||' | sed 's|feature/||' | tr -d ' ')
        remote_bugs=$(git branch -r | grep 'origin/bugfix/' | sed 's|origin/||' | sed 's|bugfix/||' | tr -d ' ')
        remote_releases=$(git branch -r | grep 'origin/release/' | sed 's|origin/||' | sed 's|release/||' | tr -d ' ')
        remote_hotfixes=$(git branch -r | grep 'origin/hotfix/' | sed 's|origin/||' | sed 's|hotfix/||' | tr -d ' ')

        # Get only the remote branches that are not tracked locally
        feats+=$(echo "$remote_feats" | grep -vxFf <(echo "$local_feats"))
        bugs+=$(echo "$remote_bugs" | grep -vxFf <(echo "$local_bugs"))
        releases+=$(echo "$remote_releases" | grep -vxFf <(echo "$local_releases"))
        hotfixes+=$(echo "$remote_hotfixes" | grep -vxFf <(echo "$local_hotfixes"))

        # Convert multiline to array
        feats=("${(f)feats}")
        bugs=("${(f)bugs}")
        releases=("${(f)releases}")
        hotfixes=("${(f)hotfixes}")

        echo "Tracking all git flow branches..."
        echo "--------------------------------"
        echo "Features: "
        for branch in $feats; do
            echo "$branch"
            git flow feature track "$branch"
            git pull 
        done

        echo "Bugs: "
        for branch in $bugs; do
            echo "$branch"
            git flow bugfix track "$branch"
            git pull
        done

        echo "Releases: "
        for branch in $releases; do
            echo "$branch"
            git flow release track "$branch"
            git pull
        done

        echo "Hotfixes: "
        for branch in $hotfixes; do
            echo "$branch"
            git checkout "hotfix/$branch"
            git pull
        done

        git checkout develop
}

function git_flow_pull_all() {
    git fetch --all
    local feats bugs releases hotfixes

    feats=$(git branch | grep 'feature/' | sed 's|feature/||' | tr -d ' ')
    bugs=$(git branch | grep 'bugfix/' | sed 's|bugfix/||' | tr -d ' ')
    releases=$(git branch | grep 'release/' | sed 's|release/||' | tr -d ' ')
    hotfixes=$(git branch | grep 'hotfix/' | sed 's|hotfix/||' | tr -d ' ')
    
    feats=("${(f)feats}")
    bugs=("${(f)bugs}")
    releases=("${(f)releases}")
    hotfixes=("${(f)hotfixes}")
    
    echo "Pulling all git flow feature branches..."
    echo "--------------------------------"
    for branch in $feats; do
        echo "Checking out and pulling feature/$branch"
        git checkout "feature/$branch" && git pull
    done

    echo "Pulling all git flow bugfix branches..."
    echo "--------------------------------"
    for branch in $bugs; do
        echo "Checking out and pulling bugfix/$branch"
        git checkout "bugfix/$branch" && git pull
    done

    echo "Pulling all git flow release branches..."
    echo "--------------------------------"
    for branch in $releases; do
        echo "Checking out and pulling release/$branch"
        git checkout "release/$branch" && git pull
    done

    echo "Pulling all git flow hotfix branches..."
    echo "--------------------------------"
    for branch in $hotfixes; do
        echo "Checking out and pulling hotfix/$branch"
        git checkout "hotfix/$branch" && git pull
    done

    git checkout develop
}
