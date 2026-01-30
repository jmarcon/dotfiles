#!/bin/zsh

###############################################################################
# GENERAL UTILITY FUNCTIONS
# A collection of utility functions for formatting output and debugging
###############################################################################

# Print a boxed title with decorative border
# Usage: notify "Your Title"
function notify() {
	local len=$((${#1} + 2))
	printf "\n+"
	printf -- "-%.0s" $(seq 1 $len)
	printf "+\n| $1 |\n+"
	printf -- "-%.0s" $(seq 1 $len)
	printf "+\n\n"
}

# Print text in specified color
# Usage: print_color "Message" "color_name"
# Available colors: black, red, green, yellow, blue, magenta, cyan, orange, white
function print_color() {
	local message="$1"
	local color="${2:-white}" # Default to white if no color specified
	local color_code=""

	# Map color names to ANSI color codes
	case "$color" in
	"black") color_code="30" ;;
	"red") color_code="31" ;;
	"green") color_code="32" ;;
	"yellow") color_code="33" ;;
	"blue") color_code="34" ;;
	"magenta") color_code="35" ;;
	"cyan") color_code="36" ;;
	"orange") color_code="91" ;;
	"white") color_code="37" ;;
	*) color_code="37" ;; # Default to white for unknown colors
	esac

	# Print colored message
	echo -e "\033[0;${color_code}m$message\033[0m"
}

# Display a title with an underline of equal length
# Usage: show_title "Your Title" "color_name"
function show_title() {
	local title="$1"
	local color="${2:-white}"

	local title_length=${#title}
	local title_line=$(printf "%${title_length}s" | tr ' ' '=')

	if [[ -z "$color" ]]; then
		color="white"
	fi

	print_color "$title" "$color"
	print_color "$title_line" "$color"
}

# Print debug messages only when DEBUG_DOTFILES is set to "true"
# Usage: print_debug "Debug message" "color_name"
function print_debug() {
	[[ "$DEBUG_DOTFILES" == "true" ]] && print_color "$1" "$2"
}

function verify_commands() {
	local command_name
	for command_name in "$@"; do
		if ! command -v "$command_name" >/dev/null 2>&1; then
			print_debug "      $command_name not installed" 'red'
			return 1
		fi
	done
}

function add_in_path() {
	if [[ -z "$1" ]]; then
		print_debug "Usage: add_in_path <path>" 'orange'
		return 1
	fi

	if [[ ! -d "$1" ]]; then
		print_debug "Directory $1 does not exist." 'red'
		return 1
	fi

	if [[ ":$PATH:" == *":$1:"* ]]; then
		print_debug "Path $1 is already in PATH." 'yellow'
		return 0
	fi

	export PATH="$1:$PATH"
	print_debug "Added $1 to PATH." 'green'
}

function clean_path() {
	local new_path=""
	# Split PATH by colon and iterate
	IFS=':' read -r -A arr <<<"$PATH"

	for dir in "${arr[@]}"; do
		print_debug "Processing directory: $dir" 'blue'

		if [[ -z "$dir" ]]; then
			print_debug "Skipping empty directory in PATH" 'yellow'
			continue
		fi

		if [[ ! -d "$dir" ]]; then
			print_debug "Removing non-existent directory from PATH: $dir" 'red'
			continue
		fi

		# Check if the directory is already in new_path
		if [[ ":$new_path:" == *":$dir:"* ]]; then
			print_debug "Skipping duplicate directory in PATH: $dir" 'yellow'
			continue
		fi

		new_path="$new_path:$dir"
	done

	new_path="${new_path#:}" # Remove leading colon
	# echo $new_path | tr ':' '\n' | nl
	export PATH=$new_path
}
