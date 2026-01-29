# DOTFILES KNOWLEDGE BASE

**Generated:** 2026-01-29
**Commit:** N/A
**Branch:** N/A

## OVERVIEW
Cross-platform dotfiles repository with synchronized PowerShell and ZSH profiles for consistent shell experience across Windows, macOS, and Linux. Modular configuration system with 31+ cross-platform functions.

## STRUCTURE
```
dotfiles/
├── Config/
│   ├── pwsh/profile/        # PowerShell profiles (20 files, numbered load order)
│   ├── zsh/                # ZSH profiles (48 files, modular loaders)
│   │   ├── functions/        # ZSH functions (14 files)
│   │   ├── aliases/          # ZSH aliases (11 files)
│   │   ├── env/             # Environment variables (6 files)
│   │   ├── init/            # Initialization scripts (9 files)
│   │   └── path/            # PATH management (4 files)
│   ├── nvim/               # Neovim configuration (lazy.nvim)
│   │   └── Config/lua/plugins/  # Neovim plugins (15 files, numbered)
│   ├── tmux/               # Tmux configuration
│   └── posh/               # Oh My Posh themes
├── Install/
│   ├── linux/               # Linux installation scripts (7 files)
│   └── windows/            # Windows installation scripts (6 files)
├── .github/workflows/       # GitHub Actions (SonarQube scan)
└── README.md               # Project documentation
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| PowerShell profile entry | `Config/pwsh/profile/0000__PROFILE.ps1` | Loads all other .ps1 files in order |
| ZSH profile entry | `Config/zsh/.zshrc` | Sources global functions + modular loaders |
| Cross-platform functions | `Config/zsh/.global.functions.zsh`, `Config/pwsh/profile/1000_function_aliases.ps1` | 31+ synchronized functions, snake_case |
| Neovim config | `Config/nvim/Config/init.lua` | Uses lazy.nvim plugin manager |
| Oh My Posh theme | `Config/posh/radar.omp.toml` | Custom radar theme with multi-language support |
| Tmux config | `Config/tmux/.tmux.conf` | Prefix: Ctrl-a, TPM-based plugins |
| Linux install | `Install/linux/install.zsh` | Platform-specific installer |
| Windows install | `Install/windows/install.ps1` | Platform-specific installer |
| Local secrets | `~/.Config/env.ps1` (PWSH) or `~/.dotfiles/.env.local.zsh` (ZSH) | Not tracked by git |

## CONVENTIONS
**Deviations from standard dotfiles:**

- **No symlink/bootstrap**: Configs are sourced manually, not symlinked to home directory
- **Capitalized directories**: Uses `Config/` and `Install/` instead of lowercase `config/` and `install/`
- **Numbered load order**: Prefixes like `0000__`, `0100_`, `5000_` guarantee initialization sequence
- **Cross-platform sync**: All functions use `snake_case` naming in both PowerShell and ZSH
- **Local overrides**: Append `.local` before extension for untracked custom configs
- **Debug mode**: Set `DEBUG_DOTFILES=true` (ZSH) or `$ENV:PROFILE_DEBUG=$true` (PWSH) for verbose output
- **Modular loading**: Separate files for aliases, env, init, path, functions with auto-loaders
- **Oh My Posh**: Custom `radar.omp.toml` theme (not using default)

## ANTI-PATTERNS (THIS PROJECT)
- **No centralized setup script**: Platform-specific installers (`Install/linux/install.zsh`, `Install/windows/install.ps1`) but no bootstrap
- **No Makefile**: Build automation not needed for dotfiles (config only)
- **Minimal .gitignore**: Only ignores `*.local.*` and `automation/session.json`
- **Single OS CI**: GitHub Actions only runs on ubuntu-latest (no cross-platform validation)

## UNIQUE STYLES
- **Function synchronization**: 31+ functions maintained identically across PowerShell and ZSH (see README.md)
- **Color-coded output**: `print_color()` (ZSH) with support for black/red/green/yellow/blue/magenta/cyan/orange/white
- **Debug-aware functions**: `print_debug()` only outputs when debug mode is enabled
- **Safe PATH management**: `add_in_path()` checks existence and duplicates, `clean_path()` removes non-existent dirs
- **Multi-language version display**: Oh My Posh theme shows Node, Python, Java, Go, Rust, Dotnet versions
- **Package manager integration**: Unified `update()` function updates Scoop, Homebrew, npm, pip, and more

## COMMANDS
```bash
# Load profiles (manual setup)
source ~/dotfiles/Config/zsh/.zshrc              # ZSH
. ~/dotfiles/Config/pwsh/profile/0000__PROFILE.ps1   # PowerShell

# Update all tools
update                    # Updates Scoop/Homebrew, npm, pip, etc.

# Common shortcuts (available in both shells)
gs                        # git status
gp                        # git pull
kgp                       # kubectl get pods
dps                       # docker ps -a

# Reload profiles
reload                    # ZSH: source ~/.zshrc
. $PROFILE                # PowerShell: reload profile
```

## NOTES
- **Profile loading order matters**: Files are loaded in numerical order (`0000_` first, `6000_` last)
- **Local overrides**: Create `.local.zsh` or `.local.ps1` files for machine-specific config (gitignored)
- **Secrets**: Use `~/.Config/env.ps1` (PWSH) or `~/.dotfiles/.env.local.zsh` (ZSH) for sensitive data
- **Oh My Posh requires NerdFont**: Install FiraCode-NF, JetBrainsMono-NF, or similar for proper display
- **Neovim lazy.nvim**: Plugins auto-install on first run if not present
- **Tmux TPM**: Install plugins with `prefix + I` (Ctrl-a, then I)
- **SonarQube CI**: Only runs code analysis, no actual build/test steps (workflow name is misleading)
- **Bun support**: ZSH auto-adds `$HOME/.bun` to PATH if detected
- **Homebrew completions**: ZSH auto-loads from `/opt/homebrew/share/zsh/site-functions` (macOS) or `/home/linuxbrew/.linuxbrew/share/zsh/site-functions` (Linux)
