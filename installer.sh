#!/usr/bin/env bash

set -euo pipefail

REPO_USER="b-sn"
REPO_NAME="config"
BRANCH="main"
SCRIPT_NAME=$(basename "$0")

if [[ $# -lt 1 ]]; then
    if ! command -v jq >/dev/null 2>&1; then
      sudo apt-get update
      sudo apt-get -y install jq
    fi

    response=$(curl -s "https://api.github.com/repos/$REPO_USER/$REPO_NAME/contents/?ref=$BRANCH")
    if [[ -z "$response" ]]; then
      echo "Error: empty response from GitHub."
      exit 1
    fi

    echo -e "\nUsage: $0 <app-name>"
    echo "Supported app-names:"

    echo "$response" | jq -r '.[].name' | while read filename; do
        if [[ "$filename" =~ ^install_([a-zA-Z0-9_-]+)\.sh$ ]]; then
            echo -e "\t${BASH_REMATCH[1]}"
        fi
    done
    exit 1
fi

FILE="$1"
URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}/install_${FILE}.sh"

echo "Downloading and executing: $URL"
curl -sSL -H "Cache-Control: no-cache" "$URL" | bash
