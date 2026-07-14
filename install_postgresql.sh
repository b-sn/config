#!/usr/bin/env bash

# Source: https://www.postgresql.org/download/linux/debian/

sudo apt install -y curl ca-certificates
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc

sudo cat > /etc/apt/sources.list.d/pgdg.sources << EOF
Types: deb deb-src
URIs: https://apt.postgresql.org/pub/repos/apt
Suites: trixie-pgdg
Architectures: amd64
Components: main
Signed-By: /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc
EOF

sudo apt update
sudo apt install -y postgresql-18
