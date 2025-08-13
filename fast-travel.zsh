#!/bin/zsh

HOSTS_FILE="$HOME/.ssh/hosts/hosts.txt"
KEY_DIR="$HOME/.ssh/keys"

# ---------------------------------------
# Fast Travel
# ---------------------------------------
function fast-travel() {
  local checkpoint=$1
  if [[ -z "$checkpoint" ]]; then
    echo "⚠️  Usage: fast-travel <checkpoint-name>"
    return 1
  fi

  # Try to match the checkpoint name
  IFS=' ' read -r name host third fourth <<< "$(grep -E "^$checkpoint " "$HOSTS_FILE")"

  if [[ -z "$host" ]]; then
    echo "❌ Checkpoint '$checkpoint' not found in $HOSTS_FILE"
    return 1
  fi

  # Determine login method
  if [[ "$third" == *.pem ]]; then
    local pem="$third"
    local user="$fourth"
    if [[ -z "$user" ]]; then
      echo "❌ PEM entry missing username."
      return 1
    fi
    echo "✨ Fast-travelling (PEM) to $checkpoint... 🧭"
    ssh -i "$KEY_DIR/$pem" -o IdentitiesOnly=yes "$user@$host"
  else
    local user="$third"
    echo "✨ Fast-travelling (User) to $checkpoint... 🧭"
    ssh "$user@$host"
  fi
}

# ---------------------------------------
# Add Travel
# ---------------------------------------
function add-travel() {
  local name=$1
  local host=$2
  local third=$3
  local fourth=$4

  echo "⚡ Adding new checkpoint..."

  if [[ -z "$name" || -z "$host" || -z "$third" ]]; then
    echo "⚠️  Usage:"
    echo "  For PEM:  add-travel <name> <host> <pem-file> <username>"
    echo "  For user: add-travel <name> <host> <username>"
    return 1
  fi

  if grep -q "^$name " "$HOSTS_FILE" 2>/dev/null; then
    echo "❌ Checkpoint '$name' already exists. Remove it first."
    return 1
  fi

  if [[ "$third" == *.pem ]]; then
    if [[ -z "$fourth" ]]; then
      echo "❌ PEM entry requires username."
      return 1
    fi
    echo "$name $host $third $fourth" >> "$HOSTS_FILE"
  else
    echo "$name $host $third" >> "$HOSTS_FILE"
  fi

  echo "✅ Checkpoint '$name' added."
}

# ---------------------------------------
# Remove Travel
# ---------------------------------------
function remove-travel() {
  local name=$1
  if [[ -z "$name" ]]; then
    echo "⚠️  Usage: remove-travel <checkpoint-name>"
    return 1
  fi

  sed -i "" "/^$name /d" "$HOSTS_FILE"
  echo "❌ Checkpoint '$name' removed."
}

# ---------------------------------------
# Tab Completion
# ---------------------------------------
function _fast_travel_completions() {
  local words
  words=($(grep -v "^$" "$HOSTS_FILE" | awk '{print $1}'))
  compadd "${words[@]}"
}

compdef _fast_travel_completions fast-travel