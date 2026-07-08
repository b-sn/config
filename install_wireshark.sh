#!/usr/bin/env bash

# Wireshark
# Source: https://www.wireshark.org/docs/wsdg_html_chunked/ChSetupUNIX.html#ChSetupUNIXBuildEnvironmentSetup

if command -v wireshark 2>/dev/null; then
  echo "Wireshark already installed"
  exit
fi

START_DIR="$PWD"

# Ninja
# Source https://github.com/ninja-build/ninja

if ! command -v ninja 2>/dev/null; then
  sudo apt-get install re2c

  BUILD_DIR="$(mktemp -d)"
  cd "$BUILD_DIR"

  git clone https://github.com/ninja-build/ninja.git && cd ninja
  cmake -Bbuild-cmake -DBUILD_TESTING=OFF
  cmake --build build-cmake
  sudo cp ./build-cmake/ninja /usr/local/bin

  cd "$START_DIR"
  rm -fR "$BUILD_DIR"
fi

STABLE_RELEASE=$(curl https://www.wireshark.org/download.html 2>/dev/null | grep -v Old | grep -Po 'Stable Release: [\.\d]+' | cut -d' ' -f3)
echo "Version will be installed: $STABLE_RELEASE"

BUILD_DIR="$(mktemp -d)"
cd "$BUILD_DIR"

git clone https://gitlab.com/wireshark/wireshark.git && cd ./wireshark
git checkout "v${STABLE_RELEASE}"
sudo ./tools/debian-setup.sh --install-optional --install-qt6-deps --install-deb-deps -y

mkdir build
cd ./build
cmake -G Ninja ..
ninja
sudo ninja install
sudo setcap cap_net_raw,cap_net_admin=ep "$(command -v dumpcap)"

cd "$START_DIR"
rm -fR "$BUILD_DIR"
