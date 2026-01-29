#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5600] - Files and Folders' 'yellow'


# Function to handle deletion with confirmation
function remove_deps() {
  local pattern="$1"
  local items=($(find "$current_dir" -name "$pattern" -type d -o -name "$pattern" -type f 2>/dev/null))

  for item in "${items[@]}"; do
    echo "Found: $item"
    read -q "REPLY?Delete this item? (y/n) "
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      if [[ -d "$item" ]]; then
        rm -rf "$item"
      else
        rm -f "$item"
      fi
      count=$((count + 1))
      echo "Deleted: $item"
    else
      echo "Skipped: $item"
    fi
  done
}

function clean_deps() {
  local language="$1"
  local current_dir="$(pwd)"
  local all_deps=0
  local count=0

  # Define dependency patterns for each language
  local python_deps=(".venv" "__pycache__" "*.pyc" "*.pyo" "*.egg-info" "dist" "build")
  local dotnet_deps=("bin" "obj" ".vs" "packages" "*.user")
  local nodejs_deps=("node_modules" "package-lock.json" "yarn.lock" "npm-debug.log")
  local java_deps=("target" "build" ".gradle" "*.class" "*.jar")
  local ruby_deps=("vendor/bundle" ".bundle" "*.gem")
  local go_deps=("vendor" "go.sum")
  local rust_deps=("target" "Cargo.lock")

  # If no language specified, clean all
  if [[ -z "$language" ]]; then
    all_deps=1
    echo "No language specified. Cleaning all dependency folders..."
  else
    echo "Cleaning $language dependency folders..."
  fi

  # Clean Python dependencies
  if [[ "$language" == "python" || $all_deps -eq 1 ]]; then
    echo "\nScanning for Python dependencies..."
    for pattern in "${python_deps[@]}"; do
      remove_deps "$pattern"
    done
  fi

  # Clean .NET dependencies
  if [[ "$language" == "dotnet" || $all_deps -eq 1 ]]; then
    echo "\nScanning for .NET dependencies..."
    for pattern in "${dotnet_deps[@]}"; do
      remove_deps "$pattern"
    done
  fi

  # Clean Node.js dependencies
  if [[ "$language" == "nodejs" || "$language" == "node" || $all_deps -eq 1 ]]; then
    echo "\nScanning for Node.js dependencies..."
    for pattern in "${nodejs_deps[@]}"; do
      remove_deps "$pattern"
    done
  fi

  # Clean Java dependencies
  if [[ "$language" == "java" || $all_deps -eq 1 ]]; then
    echo "\nScanning for Java dependencies..."
    for pattern in "${java_deps[@]}"; do
      remove_deps "$pattern"
    done
  fi

  # Clean Ruby dependencies
  if [[ "$language" == "ruby" || $all_deps -eq 1 ]]; then
    echo "\nScanning for Ruby dependencies..."
    for pattern in "${ruby_deps[@]}"; do
      remove_deps "$pattern"
    done
  fi

  # Clean Go dependencies
  if [[ "$language" == "go" || $all_deps -eq 1 ]]; then
    echo "\nScanning for Go dependencies..."
    for pattern in "${go_deps[@]}"; do
      remove_deps "$pattern"
    done
  fi

  # Clean Rust dependencies
  if [[ "$language" == "rust" || $all_deps -eq 1 ]]; then
    echo "\nScanning for Rust dependencies..."
    for pattern in "${rust_deps[@]}"; do
      remove_deps "$pattern"
    done
  fi

  echo "\nCleaning complete. Removed $count dependency items."
}
