#!/bin/zsh
print_debug '  ♾️️ Loading Environment Variables [1100] - FD and FZF' 'yellow'

verify_commands fzf fd || return 1

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git --preview 'cat {}'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# If bat is available, use it for previews
if verify_commands bat; then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
else
    export FZF_CTRL_T_OPTS="--preview 'cat {}'"
fi

# If eza is available, use it for previews
if verify_commands eza; then
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
else
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
fi

## Setup the FZF Theme || https://vitormv.github.io/fzf-themes/
# https://vitormv.github.io/fzf-themes#eyJib3JkZXJTdHlsZSI6ImJvbGQiLCJib3JkZXJMYWJlbCI6IiAgZnpmIHwgZmQgICIsImJvcmRlckxhYmVsUG9zaXRpb24iOjAsInByZXZpZXdCb3JkZXJTdHlsZSI6InJvdW5kZWQiLCJwYWRkaW5nIjoiMCIsIm1hcmdpbiI6IjAiLCJwcm9tcHQiOiLilrbvuI/vuI8gIiwibWFya2VyIjoiWyIsInBvaW50ZXIiOiI+Iiwic2VwYXJhdG9yIjoi44Cw77iP77iPIiwic2Nyb2xsYmFyIjoi4pWsIiwibGF5b3V0IjoicmV2ZXJzZSIsImluZm8iOiJyaWdodCIsImNvbG9ycyI6ImZnOiNGOEY4RjIsZmcrOiNCRDkzRjksYmc6IzI4MkEzNixiZys6IzQ0NDc1QSxobDojOEJFOUZELGhsKzojNTBGQTdCLGluZm86I0YxRkE4QyxtYXJrZXI6I0YxRkE4Qyxwcm9tcHQ6I0ZGNTU1NSxzcGlubmVyOiNGRjc5QzYscG9pbnRlcjojRkZCODZDLGhlYWRlcjojNjI3MkE0LGd1dHRlcjojMjgyQTM2LGJvcmRlcjojNjI3MkE0LHNlcGFyYXRvcjojRjFGQThDLHNjcm9sbGJhcjojNDQ0NzVBLHByZXZpZXctYmc6IzFlMWYyNixwcmV2aWV3LWJvcmRlcjojQkQ5M0Y5LGxhYmVsOiM2MjcyQTQscXVlcnk6I2Q5ZDlkOSxkaXNhYmxlZDojNjI3MkE0In0=
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#F8F8F2,fg+:#BD93F9,bg:#282A36,bg+:#44475A
  --color=hl:#8BE9FD,hl+:#50FA7B,info:#F1FA8C,marker:#F1FA8C
  --color=prompt:#FF5555,spinner:#FF79C6,pointer:#FFB86C,header:#6272A4
  --color=gutter:#282A36,border:#6272A4,separator:#F1FA8C,scrollbar:#44475A
  --color=preview-bg:#1e1f26,preview-border:#BD93F9,label:#6272A4,query:#d9d9d9
  --color=disabled:#6272A4
  --border="bold" --border-label="  fzf | fd  " --border-label-pos="0" --preview-window="border-rounded"
  --prompt="▶️️ " --marker="[" --pointer=">" --separator="〰️️"
  --scrollbar="╬" --layout="reverse" --info="right"'
