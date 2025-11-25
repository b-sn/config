#!/usr/bin/env bash

set -euo pipefail

REPO_USER="b-sn"
REPO_NAME="config"
BRANCH="main"
SCRIPT_NAME=$(basename "$0")

if [[ $# -lt 1 || "$1" == "all" ]]; then
    sudo apt-get -y install jq

    response=$(curl -s "https://api.github.com/repos/$REPO_USER/$REPO_NAME/contents/?ref=$BRANCH")
    if [[ -z "$response" ]]; then
      echo "Error: empty response from GitHub."
      exit 1
    fi

    if [[ $# -lt 1 ]]; then
        echo -e "\nUsage: $0 <script-name>"
        echo "Possible names:"
    fi
    echo "$response" | jq -r '.[].name' | while read filename; do
        if [[ "$filename" == "$SCRIPT_NAME" ]]; then
            continue
        fi
    
        if [[ "$filename" =~ ^install_([a-zA-Z0-9_-]+)\.sh$ ]]; then
            if [[ $# -lt 1 ]]; then
                echo -e "\t${BASH_REMATCH[1]}"
            else 
                URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}/$filename"
                echo "Downloading and executing: $URL"
                curl -sSL -H "Cache-Control: no-cache" "$URL" | bash
            fi
        fi
    done
    if [[ $# -lt 1 ]]; then
        echo -e "\tall - to install everything at once"
    fi
    exit 1
fi

FILE="$1"
URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}/instal_${FILE}.sh"

echo "Downloading and executing: $URL"
curl -sSL -H "Cache-Control: no-cache" "$URL" | bash
