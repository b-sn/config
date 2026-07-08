#!/usr/bin/env bash

# Source: https://github.com/keepassxreboot/keepassxc/wiki/Building-KeePassXC

if command -v keepassxc >/dev/null 2>&1; then
  echo "KeepAssXC already installed"
  exit
fi

sudo apt install build-essential cmake g++ asciidoctor
sudo apt install qt6-base-dev qt6-svg-dev qt6-tools-dev libusb-1.0-0-dev libbotan-3-dev zlib1g-dev libminizip-dev libpcsclite-dev libkeyutils-dev libxi-dev libxtst-dev libqrencode-dev
sudo apt install qtbase5-dev libqt5svg5-dev qttools5-dev libqt5x11extras5-dev libargon2-dev qtbase5-private-dev
git clone https://github.com/keepassxreboot/keepassxc.git

cd keepassxc
git switch --detach latest

mkdir build
cd build
cmake -DWITH_XC_NETWORKING=OFF -DWITH_XC_BROWSER=ON -DWITH_XC_SSHAGENT=ON -DCMAKE_BUILD_TYPE=Release -DWITH_ASAN=ON ..
make -j"$(nproc)"
sudo make install
