if (!(Get-Command "git" -ErrorAction SilentlyContinue)) { exit }

if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Loading Git Functions'
}

function gs { git status }
function gla { git log --oneline --all --graph --decorate }

function gitu {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    & git add .
    & git commit -am "$Message"
    & git push
}

function Update-GitRepository {
    param (
        [Parameter(Mandatory = $true)]
        [string]$RepositoryPath,

        [string]$ParentFolder = (Get-Location)
    )

    Write-Title "Git Repository: $($RepositoryPath)"
    Set-Location $RepositoryPath
    Write-Color "Fetching: ", $RepositoryPath.Split('\')[-1] -Color Yellow, White
    & git fetch --all
    
    $current_branch = & git rev-parse --abbrev-ref HEAD
    $default_branch = $(git remote show origin | rg 'HEAD branch')
    # $already = git branch -a | Select-String -Pattern "dev" -Quiet
    $already = $current_branch | Select-String -Pattern "main" -Quiet
    $main_branch = $default_branch | Select-String -Pattern "main" -Quiet
    $master_branch = $default_branch | Select-String -Pattern "master" -Quiet
    # $development = git branch -a | Select-String -Pattern "development" -Quiet
    # $develop = git branch -a | Select-String -Pattern "develop" -Quiet
    # $dev = git branch -a | Select-String -Pattern "dev" -Quiet

    Write-Color "----------------------------------------" -Color White
    Write-Color "Current Branch: ", $current_branch -Color Cyan, Yellow
    Write-Color "Default Branch: ", $default_branch -Color Cyan, Red
    Write-Color "----------------------------------------" -Color White
    Write-Color ""
    
    $has_main = $false
    if ($already) {
        $has_main = $true
        Write-Color "We are in ", "$($current_branch)" -Color Cyan, Blue
    }
    else {
        Write-Color "Trying to find a main or master branch" -Color Cyan
        if ($null -ne $main_branch) {
            Write-Color "Found ", "main ", "branch - Checkout" -Color Cyan, Red, Cyan
            git checkout main
            $has_main = $true
        }
        elseif ($null -ne $master_branch) {
            Write-Color "Found ", "master ", "branch - Checkout" -Color Cyan, Red, Cyan
            git checkout master
            $has_main = $true
        }
        # if ($null -ne $development) { 
        #     Write-Color "Found ", "development ", "branch - Checkout" -Color Cyan, Blue, Cyan
        #     git checkout development 
        # }
        # elseif ($null -ne $develop) {
        #     Write-Color "Found ", "develop ", "branch - Checkout" -Color Cyan, Blue, Cyan
        #     git checkout develop 
        # }
        # elseif ($null -ne $dev    ) { 
        #     Write-Color "Found ", "dev ", "branch - Checkout" -Color Cyan, Blue, Cyan
        #     git checkout dev 
        # }
        else {
            Write-Color "No Main/Master branch found" -Color Red
            Write-Color "We are in ", "$($current_branch)" -Color Cyan, Yellow
            $has_main = $false
        }
    }

    Write-Color "Pulling ..." -Color Yellow
    & git fetch --all
    & git pull --all
    Write-Host " "
    Set-Location $ParentFolder
    return $has_main
}

function Get-AllGitRepositories {
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$ParentFolder = (Get-Location).Path,

        [Parameter(Mandatory = $false, Position = 1)]
        [bool]$Recursive = $true
    )

    if ($Recursive) {
        Write-Title "Git Repositories in 🗂️ $($ParentFolder) | Recursive"
        # Get all git repositories in the current folder and subfolders 
        $gitrepos = Get-ChildItem $ParentFolder -Directory -Recurse -Force ".git"
        $gitrepos | ForEach-Object {
            ## Remove the .git folder from the path
            $repo = $_.FullName.Replace(".git", "")
            Write-Host "👨‍💻 Repository: $($repo)"
        }
    }
    else {
        Write-Title "Git Repositories in 🗂️ $($ParentFolder)"
        $gitrepos = Get-ChildItem $ParentFolder -Directory -Recurse -Force ".git"
        $gitrepos | ForEach-Object {
            ## Remove the .git folder from the path
            $repo = $_.FullName.Replace(".git", "")
            Write-Host "👨‍💻 Repository: $($repo)"
        }
    }
}

function Get-GitRepositoriesWithoutDev {
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$ParentFolder = (Get-Location).Path
    )

    Get-ChildItem $ParentFolder -Directory -Recurse | ForEach-Object {
        $repo = $_.FullName + "\.git"

        if (Test-Path $repo) {
            Set-Location $_.FullName
            $current_git_branch = & git branch | Select-String -Pattern "\*"

            $development = git branch -a | Select-String -Pattern "development" -Quiet
            $develop = git branch -a | Select-String -Pattern "develop" -Quiet
            $dev = git branch -a | Select-String -Pattern "dev" -Quiet

            if ($null -ne $development -or $null -ne $develop -or $null -ne $dev) {
                Write-Color $_.FullName, " - ", $current_git_branch, " - with dev branch" -Color White, White, Yellow, Green
            }
            else {
                Write-Color $_.FullName, " - ", $current_git_branch, " - NO dev branch" -Color White, White, Yellow, Red
            }
        
            Set-Location $ParentFolder
        }
    }
}

function Update-AllRepositories {
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$ParentFolder = (Get-Location).Path,

        [Parameter(Mandatory = $false, Position = 1)]
        [bool]$Recursive = $true
    )

    if ($Recursive) {
        $count = 0
        $tot = 0
        Get-ChildItem $ParentFolder -Directory -Recurse -Force ".git" | ForEach-Object {
            $repo = $_.FullName.Replace(".git", "")
            $tot++
            
            $has_main = Update-GitRepository -RepositoryPath $repo -ParentFolder $ParentFolder
            if ($has_main) { $count++ }
        }

        Write-Host " "
        Write-Host "----------------------------------------"
        Write-Host " "
        Write-Host "Total of $count repositories with main or master branch"
        Write-Host "Total of $tot repositories without main or master branch"
        Write-Host " "
        Write-Host "----------------------------------------"
        Write-Host " "


    }
    else {
        Get-ChildItem $ParentFolder -Directory | ForEach-Object {
            $repo = $_.FullName + "\.git"
            if (Test-Path $repo) {
                $has_main = Update-GitRepository -RepositoryPath $_.FullName -ParentFolder $ParentFolder
                if ($has_main) { $count++ }
            }
        }
    }
}

function Git-GetAllBranches {
    # Verify if the current directory is a git repository
    if(-not (Test-Path -Path ".git")) {
        return
    }

    $AllBranches = git branch -r
    $AllBranches | ForEach-Object {
        $remote = $_ -replace '\x1B\[[0-9;]*[a-zA-Z]', ''
        if($remote -notmatch '->') {
            $localBranch = $remote -replace 'origin/', ''
            $localBranch = $localBranch.Trim()
            $remote = $remote.Trim()
            # echo "git branch --track ""$localBranch"" ""$remote"""
            echo "Tracking Branch ${localBranch}"
            git branch --track "${localBranch}" "${remote}"
        }
    }

    git fetch --all
    git pull --all
}

# function Git-SetDefaultConfig {
#     git config --global color.ui auto
#     git config --global fetch.prune true
#     git config --global pull.ff only
#     git config --global core.pager cat 
#     git config --global editor "code --wait"
#     git config --global grep.break true
#     git config --global grep.heading true 
#     git config --global grep.lineNumber true
#     git config --global grep.extendedRegexp true
#     git config --global log.abbrevCommit true
#     git config --global log.follow true
#     git config --global merge.ff false
# }