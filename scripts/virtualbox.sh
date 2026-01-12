#!/bin/bash
set -eux

sudo mkdir -p /media/VBoxGuestAdditions
sudo mount /home/vagrant/VBoxGuestAdditions.iso /media/VBoxGuestAdditions
sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run || true
sudo umount /media/VBoxGuestAdditions
sudo rm -rf /media/VBoxGuestAdditions
sudo rm -f /home/vagrant/VBoxGuestAdditions.iso
