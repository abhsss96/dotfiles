#!/bin/bash

# Script to install xdotool and wmctrl on Ubuntu

echo "Updating package lists..."
sudo apt-get update

echo "Installing xdotool and wmctrl..."
sudo apt-get install -y xdotool wmctrl

echo "Installation complete."
