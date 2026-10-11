
#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Error: run this script as root" >&2
    exit 1
fi

source /etc/os-release

if [[ "${ID:-}" != "debian" ]]; then
    echo "Error: only Debian is supported" >&2
    exit 1
fi

case "${VERSION_CODENAME:-}" in
    bullseye|bookworm|trixie) ;;
    *)
        echo "Error: unsupported Debian release" >&2
        exit 1
        ;;
esac

# Install prerequisites
sudo apt-get update
sudo apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    debian-archive-keyring

# Download and verify nginx signing key
KEYRING="/usr/share/keyrings/nginx-archive-keyring.gpg"
EXPECTED_FINGERPRINT="573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62"

TMP_KEY=$(mktemp)
trap 'rm -f "$TMP_KEY"' EXIT

curl -fsSL https://nginx.org/keys/nginx_signing.key \
    | gpg --batch --yes --dearmor -o "$TMP_KEY"

if ! gpg --batch --show-keys --with-colons "$TMP_KEY" \
    | grep -Fqx "fpr:::::::::$EXPECTED_FINGERPRINT:"; then
    echo "Error: nginx signing key fingerprint mismatch" >&2
    exit 1
fi

sudo install -m 644 "$TMP_KEY" "$KEYRING"

# Configure official nginx stable repository
cat > /etc/apt/sources.list.d/nginx.list <<EOF
deb [signed-by=$KEYRING] https://nginx.org/packages/debian ${VERSION_CODENAME} nginx
EOF

# Prefer packages from nginx.org
cat > /etc/apt/preferences.d/99nginx <<'EOF'
Package: *
Pin: origin nginx.org
Pin: release o=nginx
Pin-Priority: 900
EOF

# Install nginx
sudo apt-get update
sudo apt-get install -y nginx

# Enable and start nginx
sudo systemctl enable --now nginx

# Verify installation
sudo nginx -v
sudo systemctl is-active nginx
