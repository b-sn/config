#!/usr/bin/env bash

set -euo pipefail

BASE_URL="https://download.documentfoundation.org/libreoffice/stable"

# Check architecture
if [[ "$(dpkg --print-architecture)" != "amd64" ]]; then
    echo "Error: this script supports only Debian amd64 (x86-64)." >&2
    exit 1
fi

# Check tools
for cmd in curl file tar sort grep sed find; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: required command '$cmd' is not installed." >&2
        exit 1
    fi
done

echo "Looking for the latest LibreOffice version..."

VERSION="$(
    curl -fsSL "${BASE_URL}/" |
        grep -oE 'href="[0-9]+\.[0-9]+\.[0-9]+/"' |
        sed -E 's/^href="([^"]+)\/"$/\1/' |
        sort -V |
        tail -n1
)"

if [[ -z "$VERSION" ]]; then
    echo "Error: cannot determine the latest LibreOffice version." >&2
    exit 1
fi

echo "Latest version: $VERSION"

DOWNLOAD_DIR="${BASE_URL}/${VERSION}/deb/x86_64"

ARCHIVE="$(
    curl -fsSL "${DOWNLOAD_DIR}/" |
        grep -oE "LibreOffice_${VERSION//./\\.}_Linux_x86-64_deb\.tar\.gz" |
        head -n1
)"

if [[ -z "$ARCHIVE" ]]; then
    echo "Error: cannot find LibreOffice DEB archive." >&2
    exit 1
fi

URL="${DOWNLOAD_DIR}/${ARCHIVE}"

WORKDIR="$(mktemp -d /tmp/libreoffice-install.XXXXXX)"
trap 'rm -rf "$WORKDIR"' EXIT

# _apt must be able to open WORKDIR
chmod 755 "$WORKDIR"

cd "$WORKDIR"

echo "Downloading:"
echo "$URL"

curl -fL --progress-bar "$URL" -o "$ARCHIVE"

echo
echo "Checking archive format..."

FILE_TYPE="$(file -b "$ARCHIVE")"
echo "Detected: $FILE_TYPE"

case "$FILE_TYPE" in
    *"gzip compressed data"* | *"POSIX tar archive"* | *"tar archive"*)
        ;;
    *)
        echo "Error: downloaded file is not a gzip/tar archive." >&2
        exit 1
        ;;
esac

# check archive
if ! tar -tf "$ARCHIVE" >/dev/null 2>&1; then
    echo "Error: archive is corrupted or is not a valid tar archive." >&2
    exit 1
fi

echo "Archive is valid."
echo "Extracting..."

tar -xf "$ARCHIVE"

DEBS_DIR="$(find "$WORKDIR" -type d -name DEBS -print -quit)"

if [[ -z "$DEBS_DIR" ]]; then
    echo "Error: DEBS directory was not found in the archive." >&2
    exit 1
fi

echo "Installing LibreOffice $VERSION..."

sudo apt install "$DEBS_DIR"/*.deb

echo
echo "LibreOffice $VERSION installed successfully."
