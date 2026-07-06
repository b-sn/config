#!/usr/bin/env bash

# Source: https://www.smartmontools.org/wiki/Download

sudo apt-get update
sudo apt-get -y install git automake libtool

git clone https://github.com/smartmontools/smartmontools

cd smartmontools
./autogen.sh
./configure
make
sudo make install
cd ../
rm -fR smartmontools

sudo /usr/sbin/update-smart-drivedb
