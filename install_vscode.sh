#!/usr/bin/env bash

# Source: https://code.visualstudio.com/docs/setup/linux

# Install the signing key
sudo apt-get -y install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f microsoft.gpg

# Create a /etc/apt/sources.list.d/vscode.sources file with the following contents to add a reference to the upstream package repository
cat <<EOF | sudo tee /etc/apt/sources.list.d/vscode.sources
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

# Update the package cache and install the package
sudo apt-get -y install apt-transport-https
sudo apt-get update
sudo apt-get -y install code # or code-insiders

# Install keyring
sudo apt-get -y install libsecret-1-0 gnome-keyring
