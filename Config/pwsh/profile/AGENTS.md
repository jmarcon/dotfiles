# POWERSHELL PROFILE AREA

## OVERVIEW
PowerShell profile loader and modular configuration scripts for a numbered load order.

## STRUCTURE
- `0000__PROFILE.ps1` is the entry point and sources the rest in order.
- `0000_*.ps1` handles base env, then increasing prefixes layer features.
- Functionality is split by domain (aliases, completions, functions, tools).

## WHERE TO LOOK
- Bootstrapping: `0000__PROFILE.ps1`
- Environment vars: `0000_env.ps1`
- PATH management: `0100_path.ps1`
- Module loading: `0200_modules.ps1`
- Aliases: `0500_aliases.ps1`
- Completions: `0750_completions.ps1`
- Core functions: `1000_functions.ps1`
- Cross-platform wrappers: `1000_function_aliases.ps1`
- Package updates: `1001_update_functions.ps1`
- Kubernetes helpers: `1100_kubectl_functions.ps1`
- Git helpers: `1200_git_functions.ps1`
- Docker helpers: `1300_docker_functions.ps1`
- Environment/cloud helpers: `1400_environment_functions.ps1`
- GitHub CLI integration: `1500_github_integration.ps1`
- Startup/terminal init: `2000_startup.ps1`
- Oh My Posh: `3000_ohmyposh.ps1`
- PSReadLine: `4000_psreadline_profile.ps1`
- Extra tools: `5000_tools.ps1`
- AI CLI helpers: `6000_ai.ps1`

## CONVENTIONS
- Numbered prefixes define strict load order; keep new files in-range.
- Cross-platform functions use `snake_case` (see `1000_function_aliases.ps1`).
- Keep domain-specific logic in the matching file; avoid mixing concerns.

## ANTI-PATTERNS
- Skipping the loader (`0000__PROFILE.ps1`) and sourcing files ad hoc.
- Adding new modules without a numbered prefix or breaking the order.
- Duplicating functions that already exist in shared cross-platform wrappers.
