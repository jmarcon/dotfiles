#!/bin/zsh 

function show_title() {
  local title="$1"
  local title_length=${#title}
  local title_line=$(printf "%${title_length}s" | tr ' ' '=')
  print -P "%F{red}\n$title\n$title_line\n"
}