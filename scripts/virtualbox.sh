#!/bin/bash
set -eux

#sudo rm -f /home/vagrant/VBoxGuestAdditions.iso
wget -O /home/vagrant/VBoxGuestAdditions.iso https://download.virtualbox.org/virtualbox/7.2.4/VBoxGuestAdditions_7.2.4.iso

ls -l /home/vagrant

wget https://dl.fedoraproject.org/pub/epel/9/Everything/x86_64/Packages/e/epel-release-9-10.el9.noarch.rpm
sudo dnf install -y epel-release-9-10.el9.noarch.rpm
rm -f epel-release-9-10.el9.noarch.rpm

sudo dnf install -y \
  kernel-devel \
  kernel-headers \
  bzip2 \
  dkms \
  elfutils-libelf-devel

sudo mkdir -p /media/VBoxGuestAdditions

sudo mount /home/vagrant/VBoxGuestAdditions.iso /media/VBoxGuestAdditions
sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run || true
sudo umount /media/VBoxGuestAdditions
sudo rm -rf /media/VBoxGuestAdditions
sudo rm -f /home/vagrant/VBoxGuestAdditions.iso

#sudo sed -i '743i #ifndef from_timer\n#define from_timer(var, timer, field) container_of(timer, typeof(*var), field)\n#endif' /opt/VBoxGuestAdditions-*/src/vboxguest-*/vboxguest/r0drv/linux/timer-r0drv-linux.c
#sudo /sbin/rcvboxadd quicksetup vboxguest vboxsf
#sudo systemctl restart vboxadd.service
#systemctl status vboxadd.service

lsmod | grep vbox

#tail -n 50 /var/log/vboxadd-setup.log

#sudo systemctl enable --now vboxadd.service
sudo systemctl reboot

cd /lib/modules/5.14.0-658.el9.x86_64/
make oldconfig && make prepare
