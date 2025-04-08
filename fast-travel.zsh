#!/bin/zsh

HOSTS_FILE="$HOME/.ssh/hosts/hosts.txt"
KEY_DIR="$HOME/.ssh/keys"

function fast-travel() {
  local checkpoint=$1
  if [[ -z "$checkpoint" ]]; then
    echo "⚠️  Usage: fast-travel <checkpoint-name>"
    return 1
  fi
  IFS=' ' read -r name ip pem <<< "$(grep -E "^$checkpoint " "$HOSTS_FILE")"
  if [[ -z "$ip" || -z "$pem" ]]; then
    echo "❌ Checkpoint '$checkpoint' not found in $HOSTS_FILE"
    return 1
  fi
  echo "✨ Fast-travelling to $checkpoint... 🧭"
  ssh -i "$KEY_DIR/$pem" -o IdentitiesOnly=yes ubuntu@$ip
}

function add-checkpoint() {
  local name=$1
  local ip=$2
  local pem=$3
  if [[ -z "$name" || -z "$ip" || -z "$pem" ]]; then
    echo "⚠️  Usage: add-checkpoint <checkpoint-name> <ip/domain> <pem-file>"
    return 1
  fi
  if grep -q "^$" "$HOSTS_FILE"; then
    sed -i "" "0,/^$/s|^$|$name $ip $pem|" "$HOSTS_FILE"
  else
    echo "$name $ip $pem" >> "$HOSTS_FILE"
  fi
  echo "✅ Checkpoint '$name' added."
}

function remove-checkpoint() {
  local name=$1
  if [[ -z "$name" ]]; then
    echo "⚠️  Usage: remove-checkpoint <checkpoint-name>"
    return 1
  fi
  sed -i "" "s/^$name .*/ /" "$HOSTS_FILE"
  echo "❌ Checkpoint '$name' removed."
}

function _fast_travel_completions() {
  local words
  words=($(grep -v "^$" "$HOSTS_FILE" | awk '{print $1}'))
  compadd "${words[@]}"
}

compdef _fast_travel_completions fast-travel

