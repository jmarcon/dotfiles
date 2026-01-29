# ZSH CONFIG KNOWLEDGE BASE

## OVERVIEW
Modular ZSH configuration with ordered loaders and domain-specific subfolders.

## STRUCTURE
```
Config/zsh/
├── .zshrc                  # Main entry point
├── .global.functions.zsh   # Shared utilities (print_color, print_debug, add_in_path, clean_path)
├── .env.zsh                # Loader for env/*
├── .init.zsh               # Loader for init/*
├── .path.zsh               # Loader for path/*
├── .aliases.zsh            # Loader for aliases/*
├── .functions.zsh          # Loader for functions/*
├── env/                    # 1000–1500 prefixed environment scripts
├── init/                   # 2100–2999 prefixed initialization scripts
├── path/                   # 3000–3300 prefixed PATH management
├── aliases/                # 4000–4999 prefixed aliases
├── functions/              # 5000–5900 prefixed functions
├── automation/             # Automation helpers
├── .claude                 # Tool-specific config
└── .qodo                   # Tool-specific config
```

## WHERE TO LOOK
- Entry wiring and load order: `.zshrc`
- Cross-file helpers (colors, debug, PATH helpers): `.global.functions.zsh`
- Loader list for each domain: `.env.zsh`, `.init.zsh`, `.path.zsh`, `.aliases.zsh`, `.functions.zsh`
- Environment variables: `env/` (1000–1500)
- Init routines and startup behavior: `init/` (2100–2999)
- PATH additions and cleanup: `path/` (3000–3300)
- Command shortcuts: `aliases/` (4000–4999)
- Reusable ZSH functions: `functions/` (5000–5900)

## CONVENTIONS
- Numbered filename prefixes define execution order within each subfolder.
- Domain isolation: environment, init, path, aliases, and functions stay in their folders.
- Loaders are the only files sourced directly from `.zshrc`.
- Utility functions are centralized in `.global.functions.zsh` to avoid duplicates.

## ANTI-PATTERNS
- Do not place aliases or functions directly in `.zshrc`.
- Do not bypass loaders by sourcing subfiles directly.
- Do not mix env/path/init logic across folders.
- Avoid renumbering prefixes unless you intend to change load order.
