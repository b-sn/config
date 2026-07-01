#!/usr/bin/env bash

if command -v mkvtoolnix >/dev/null 2>&1; then
  echo "MkvToolNix already installed"
  exit
fi

if ! command -v wget >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get -y install wget
fi

sudo wget -O /etc/apt/keyrings/gpg-pub-moritzbunkus.gpg https://mkvtoolnix.download/gpg-pub-moritzbunkus.gpg

VERSION=$(grep '^VERSION_CODENAME=' /etc/os-release | cut -d= -f2)

cat <<EOF | sudo tee /etc/apt/sources.list.d/mkvtoolnix.download.list
deb [signed-by=/etc/apt/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/debian/ $VERSION main
deb-src [signed-by=/etc/apt/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/debian/ $VERSION main
EOF

sudo apt update
sudo apt -y install mkvtoolnix mkvtoolnix-gui
