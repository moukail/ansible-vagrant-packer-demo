#!/bin/bash
set -eux

sudo dnf install -y kernel-headers kernel-devel bzip2

sudo mkdir -p /media/VBoxGuestAdditions
sudo mount /home/vagrant/VBoxGuestAdditions.iso /media/VBoxGuestAdditions
sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run || true
sudo umount /media/VBoxGuestAdditions
sudo rm -rf /media/VBoxGuestAdditions
sudo rm -f /home/vagrant/VBoxGuestAdditions.iso

sudo systemctl reboot