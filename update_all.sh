#!/usr/bin/env bash
set -euo pipefail

echo "----------- UPDATING HUYKIRITO1201 ... -----------"
sudo dnf upgrade

echo "----------- CLEANING UP HUYKIRITO1201 ... -----------"
sudo dnf autoremove -y
sudo dnf clean all

echo "----------- DONE !!! -----------"
