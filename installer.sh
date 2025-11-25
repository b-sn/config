#!/usr/bin/env bash

set -euo pipefail

REPO_USER="b-sn"
REPO_NAME="config"
BRANCH="main"

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <script-name>"
    exit 1
fi

FILE="$1"
URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}/${FILE}"

echo "Downloading and executing: $URL"
curl -sSL -H "Cache-Control: no-cache" "$URL" | bash
