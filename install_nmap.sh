#!/usr/bin/env bash

if command -v nmap >/dev/null 2>&1; then
  echo "Nmap already installed; exit"
  exit
fi

if ! command -v git >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get -y install git
fi

START_DIR="$PWD"

MAKE_DIR="$(mktemp -d)"
cd "$MAKE_DIR"
git https://github.com/nmap/nmap.git
cd nmap

./configure
make
sudo make install

cd "$START_DIR"
rm -fR "$MAKE_DIR"
