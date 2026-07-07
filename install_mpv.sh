#!/usr/bin/env bash

if command -v mpv >/dev/null 2>&1; then
  echo "Mpv already installed; exit"
  exit
fi

START_DIR="$PWD"

sudo apt-get update
sudo apt-get -y install devscripts equivs git

MAKE_DIR="$(mktemp -d)"
cd "$MAKE_DIR"
git clone https://github.com/mpv-player/mpv-build.git
cd mpv-build

./update
mk-build-deps -s sudo -i
dpkg-buildpackage -uc -us -b -j"$(nproc)"

DEB_FILE=$(find ../ -name 'mpv_*.deb')
sudo dpkg -i "$DEB_FILE"

cd "$START_DIR"
rm -fR "$MAKE_DIR"
