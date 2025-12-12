#!/usr/bin/env bash

sudo apt-get -y install wget
sudo wget -O /etc/apt/keyrings/gpg-pub-moritzbunkus.gpg https://mkvtoolnix.download/gpg-pub-moritzbunkus.gpg

VERSION=$(grep '^VERSION_CODENAME=' /etc/os-release | cut -d= -f2)

cat <<EOF | sudo tee /etc/apt/sources.list.d/mkvtoolnix.download.list
deb [signed-by=/etc/apt/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/debian/ $VERSION main
deb-src [signed-by=/etc/apt/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/debian/ $VERSION main
EOF

sudo apt update
sudo apt install mkvtoolnix mkvtoolnix-gui
