#!/usr/bin/env bash

# Sources: 
# - https://docs.ansible.com/projects/ansible/latest/installation_guide/intro_installation.html
# - https://pipx.pypa.io/stable/how-to/install-pipx/

sudo apt install pipx
pipx ensurepath

eval "$(register-python-argcomplete pipx)"
source ~/.bashrc

pipx install --include-deps ansible
