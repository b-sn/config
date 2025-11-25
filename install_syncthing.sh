#/usr/bin/env bash

# Source
# https://apt.syncthing.net/
# https://docs.syncthing.net/users/autostart.html#linux

# Add the release PGP keys:
sudo mkdir -p /etc/apt/keyrings
sudo curl -L -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg

# The `stable-v2` channel is updated with stable release builds, usually every first Tuesday of the month.
# Add the "stable-v2" channel to your APT sources
echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable-v2" | sudo tee /etc/apt/sources.list.d/syncthing.list

# Update and install syncthing
sudo apt-get update
sudo apt-get -y install syncthing

# Enable and start the service
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
