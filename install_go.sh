#!/usr/bin/env bash
set -euo pipefail

DL_JSON_URL="https://go.dev/dl/?mode=json"
INSTALL_DIR="/usr/local"
GO_DIR="${INSTALL_DIR}/go"
PROFILE_FILE="${HOME}/.profile"
PATH_LINE='export PATH=$PATH:/usr/local/go/bin'

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "ERROR: Required command not found: $1" >&2
    exit 1
  }
}

detect_os() {
  local os
  os="$(uname -s)"
  case "$os" in
    Linux)  echo "linux" ;;
    Darwin) echo "darwin" ;;
    *)
      echo "ERROR: Unsupported OS: $os" >&2
      exit 1
      ;;
  esac
}

detect_arch() {
  local arch
  arch="$(uname -m)"
  case "$arch" in
    x86_64|amd64)        echo "amd64" ;;
    aarch64|arm64)       echo "arm64" ;;
    armv6l|armv7l)       echo "armv6l" ;;
    i386|i686)           echo "386" ;;
    ppc64le)             echo "ppc64le" ;;
    s390x)               echo "s390x" ;;
    riscv64)             echo "riscv64" ;;
    *)
      echo "ERROR: Unsupported arch: $arch" >&2
      exit 1
      ;;
  esac
}

get_latest_go_version() {
  # Returns a string like: go1.22.3 (from the "version" field of the first array element JSON)
  curl -fsSL "$DL_JSON_URL" | sed -n 's/.*"version":\s*"\([^"]\+\)".*/\1/p' | head -n 1
}

get_installed_go_version() {
  if command -v go >/dev/null 2>&1; then
    # go version go1.xx.y os/arch
    go version 2>/dev/null | awk '{print $3}'
  else
    echo ""
  fi
}

ensure_profile_path() {
  # Adds a line only if it doesn't exist (exact match)
  if [ -f "$PROFILE_FILE" ]; then
    if ! grep -Fxq "$PATH_LINE" "$PROFILE_FILE"; then
      printf "\n%s\n" "$PATH_LINE" >> "$PROFILE_FILE"
      echo "Updated: ${PROFILE_FILE} (added PATH export)"
    fi
  else
    printf "%s\n" "$PATH_LINE" > "$PROFILE_FILE"
    echo "Created: ${PROFILE_FILE} (added PATH export)"
  fi
}

main() {
  need_cmd curl
  need_cmd sed
  need_cmd awk
  need_cmd tar
  need_cmd uname
  need_cmd rm
  need_cmd head
  need_cmd grep

  local os arch latest installed filename url

  os="$(detect_os)"
  arch="$(detect_arch)"

  latest="$(get_latest_go_version)"
  if [ -z "$latest" ]; then
    echo "ERROR: Could not determine latest Go version from ${DL_JSON_URL}" >&2
    exit 1
  fi

  installed="$(get_installed_go_version)"

  filename="${latest}.${os}-${arch}.tar.gz"
  url="https://go.dev/dl/${filename}"

  echo "Latest:    ${latest}"
  echo "Installed: ${installed:-<not installed>}"
  echo "OS/Arch:   ${os}/${arch}"
  echo "Artifact:  ${filename}"

  if [ -n "$installed" ] && [ "$installed" = "$latest" ]; then
    echo "Go is already up to date. Nothing to do."
    ensure_profile_path
    exit 0
  fi

  echo "Downloading: ${url}"
  curl -fL --retry 3 --retry-delay 2 -o "$filename" "$url"

  if [ ! -f "$filename" ] || [ ! -s "$filename" ]; then
    echo "ERROR: Download failed or file is empty: $filename" >&2
    exit 1
  fi

  echo "Removing existing Go: ${GO_DIR}"
  rm -rf "$GO_DIR"

  echo "Installing to: ${INSTALL_DIR}"
  sudo tar -C "$INSTALL_DIR" -xzf "$filename"

  ensure_profile_path

  echo "Done. Restart your shell or run: source \"$PROFILE_FILE\""
  echo "Check: /usr/local/go/bin/go version"
}

main "$@"
