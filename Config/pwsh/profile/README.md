# PowerShell Profile

## Entrypoint

The 0000__PROFILE.ps1 file is the entrypoint for the PowerShell profile. This file is loaded first and is responsible for loading all other profile files.

## Usage

The profile is divided into several files to make it easier to manage. Each file is loaded in a specific order to ensure that the profile is loaded correctly.

Your profile is loaded when you start a new PowerShell session. You can edit the profile files to customize your PowerShell environment. The variable `$PROFILE` contains the path to the profile file that is currently loaded.

The suggestion is to load the 0000__PROFILE.ps1 file in your profile file. This file will load all other profile files in the correct order.

### Example of $PROFILE

```powershell
$profile_path = "YOUR_PATH_TO_THIS_PROFILE_FOLDER"
$new_profile = $profile_path + "\0000__PROFILE.ps1"

if (Test-Path $new_profile) {
    . $new_profile
}
```

## Requirements

### Softwares

- PowerShell
- Scoop

Install the required software using the following command:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

scoop install git
scoop install pwsh
```

You can find more information about Scoop in the [official documentation]()

#### Some useful Scoop packages

Add the following bucket to scoop:

```powershell
scoop bucket add extras
scoop bucket add nerd-fonts
```

##### Main

| Package     | Description                                               | Must Have |
| ----------- | --------------------------------------------------------- | --------- |
| 7zip        | File compression tool                                     | yes       |
| aws         | AWS Cli                                                   | nop       |
| base64      | Base64 encoder/decoder                                    | yes       |
| bat         | Cat substitute with superpowers                           | yes       |
| bombardier  | Http load test tool                                       | no        |
| btop        | Resource monitor with a graphical interface in terminal   | yes       |
| clink       | CMD enhancements and bash-like features                   | no        |
| clipboard   | Clipboard manager for command line                        | yes       |
| cloudflared | Cloudflare tunnel                                         | no        |
| curl        | Tool to transfer data from or to a url                    | yes       |
| curlie      | Curl with a friendly interface                            | no        |
| duf         | Disk usage tool with more features                        | yes       |
| eza         | cd command substitute                                     | yes       |
| fd          | find command substittue                                   | yes       |
| fzf         | Fuzzy finder for powershell                               | yes       |
| gawk        | GNU Awk, a text processing tool                           | yes       |
| gh          | Github cli                                                | no        |
| git         | Version control system                                    | yes       |
| helm        | Kubernetes package manager                                | yes       |
| ijhttp      | Jetbrains tool to use .http files and make http requests  | no        |
| jq          | Json processor                                            | yes       |
| k6          | Load Testing tool                                         | no        |
| k9s         | Kubernetes CLI to manage clusters                         | yes       |
| kind        | Kubernetes in Docker                                      | no        |
| krew        | Kubernetes plugin manager                                 | no        |
| kubectl     | Kubernetes CLI                                            | yes       |
| kubectx     | Kubernetes context switcher                               | no        |
| kubens      | Kubernetes namespace switcher                             | no        |
| less        | File viewer                                               | yes       |
| make        | Build automation tool                                     | yes       |
| neovim      | Text editor                                               | yes       |
| nvm         | Node version manager                                      | yes       |
| oh-my-posh  | PowerShell theme engine for a fancy prompt                | yes       |
| pwsh        | Last version of PowerShell                                | yes       |
| python      | Programming language                                      | yes       |
| ripgrep     | A much better grep substitute                             | yes       |
| sed         | Stream editor                                             | yes       |
| unzip       | File decompression tool                                   | no        |
| wget        | File downloader for command line                          | yes       |
| winfetch    | Windows system information tool - lsb_release for windows | no        |
| yq          | YAML processor - JSON like jq                             | yes       |
| zoxide      | cd command substitute                                     | yes       |

##### Extras

| Package          | Description                                  | Must Have |
| ---------------- | -------------------------------------------- | --------- |
| Terminal-Icons   | Add icons to the terminal                    | no        |
| Bruno            | A Http Client, git friendly, postman similar | yes       |
| EarTrumpet       | Volume control for Windows                   | no        |
| jenv             | Java version Manager                         | yes       |
| lazygit          | A simple terminal UI for git commands        | no        |
| onefetch         | Git repository summary                       | yes       |
| plantuml         | Uml diagram generator                        | yes       |
| posh-docker      | Docker completion for oh-my-posh             | yes       |
| posh-git         | Git completion for oh-my-posh                | yes       |
| powertoys        | Windows power toys for productivity          | yes       |
| psfzf            | PowerShell wrapper for fuzzy finder (fzf)    | yes       |
| psreadline       | PowerShell module for readline               | yes       |
| scoop-completion | Scoop completion for powershell              | yes       |
| sfsu             | Scoop speed up                               | yes       |
| upscayl          | Upscale images in windows                    | no        |
| vlc              | Video Player with support for many codecs    | yes       |
| vscode           | Visual Studio Code                           | yes       |

##### Fonts

| Package           | Description                                   | Must Have |
| ----------------- | --------------------------------------------- | --------- |
| Cascadia-Code     | Fun monospaced font                           | yes       |
| CascadiaCode-NF   | Fun monospaced font                           | no        |
| DejaVuSansMono-NF | Vera Font based with NerdFont support         | no        |
| FiraCode          | Monospaced font with ligatures                | yes       |
| FiraCode-NF       | Monospaced font with ligatures                | yes       |
| Font-Awesome      | Iconic font                                   | no        |
| Inconsolata-NF    | Open-source monospace font for code listings  | no        |
| Iosevka-NF        | designed for writing code, using in terminals | no        |
| JetBrainsMono-NF  | Typeface for developers                       | yes       |
| Meslo-NF          | Customized version of Apple's Meslo font      | yes       |
| RobotoMono-NF     | Ubuntu font with NerdFont support             | yes       |

## Files

### 0000__PROFILE.ps1

This file is the entrypoint for the PowerShell profile. It loads all other profile files in the correct order.

It will load the files in the following order:

1. 0000_env.ps1
1. 0100_paths.ps1
1. 0200_modules.ps1
1. 0500_aliases.ps1
1. 0750_completions.ps1
1. 1000_functions.ps1
1. 1001_update_functions.ps1
1. 1100_kubectl_functions.ps1
1. 1200_git_functions.ps1
1. 1300_docker_functions.ps1
1. 2000_startup.ps1
1. 3000_ohmyposh.ps1
1. 4000_psreadline_profile.ps1

### 0000_env.ps1 : The Environment Variables

Contains environment variables that are loaded when the profile is loaded. It will try to load the file `env.ps1` in the `.Config` folder in the user's home directory.

The approach above allows you to have environment variables that are not shared in the repository. This is useful when you have sensitive information in the environment variables.

You should put the following code in the `env.ps1` file:

```powershell
# Example of env.ps1
$ENV:MY_SECRET = "my_secret_value"
$ENV:MY_DEVOPS_TOKEN = "my_devops_token"
```

### 0100_paths.ps1 : The Paths

It contains the paths that are added to the `$env:PATH` variable.

### ### 0200_modules.ps1 : PowerShell Modules

Loads modules that are installed in the user's environment.

### 0500_aliases.ps1 : Aliases to simplify your life

Contains aliases to improve your productivity in PowerShell and create some standard commands user friendly.

### 0750_completions.ps1 : PS Completions

Contains completions for PowerShell commands.

### 1000_functions.ps1 : Where aliases are not enough

Functions very useful for day-to-day tasks and shortcuts.

### 1001_update_functions.ps1

It helps to keep your environment up to date. It contains functions to update Scoop, PowerShell, and other tools.

Usage:

```powershell
# It will update all packages installed by tools
update
```

### 1100_kubectl_functions.ps1

Some helpers and shortcuts to improve the use of kubectl in command line.

> Some Examples:

```powershell

# Get all pods in all namespaces
kgp

# Get all services in all namespaces
kgs

```

### 1200_git_functions.ps1

Git helpers and shortcuts

> Some Examples:

```powershell
# Git status
gs

# Find all git repositories in the current directory and fetch
Update-AllRepositories
```

### 1300_docker_functions.ps1

Docker related shortcuts

```powershell
# All docker containers (Docker ps -a)
dps
```

### 2000_startup.ps1

After all the important profile files are loaded, the 2000_startup.ps1 file is loaded.

This file is responsible for setting up the terminal environment.

### 3000_ohmyposh.ps1

Configure oh-my-posh to have a fancy prompt in PowerShell.

### 4000_psreadline_profile.ps1

The PSReadline module is a PowerShell module that provides command-line editing and history capabilities.

This file is responsible for configuring the PSReadline module and more...
