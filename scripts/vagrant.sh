#!/bin/bash
set -eux

# Install Vagrant SSH key
#mkdir -p /home/vagrant/.ssh
#curl -fsSL https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub \
#  -o /home/vagrant/.ssh/authorized_keys

#chmod 700 /home/vagrant/.ssh
#chmod 600 /home/vagrant/.ssh/authorized_keys
#chown -R vagrant:vagrant /home/vagrant/.ssh

# Optimize DNF
#echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf

#sudo dnf install -y \
#  kernel-devel-$(uname -r) \
#  kernel-headers-$(uname -r) \
#  gcc \
#  make \
#  perl \
#  bzip2 tar wget \
#  elfutils-libelf-devel

sudo mkdir -p /media/VBoxGuestAdditions
sudo mount /home/vagrant/VBoxGuestAdditions.iso /media/VBoxGuestAdditions
sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run || true
sudo umount /media/VBoxGuestAdditions
sudo rm -rf /media/VBoxGuestAdditions
sudo rm -f /home/vagrant/VBoxGuestAdditions.iso

#sudo systemctl reboot
