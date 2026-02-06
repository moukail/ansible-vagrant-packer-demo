#!/bin/bash
set -eux

sudo dnf install -y bc flex bison elfutils-libelf-devel openssl-devel

cd $(mktemp -d)

wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.18.5.tar.xz
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.197.tar.xz

tar -xf linux-5.15.197.tar.xz
cd linux-5.15.197

make clean
make mrproper

#cp /boot/config-$(uname -r) .config
make defconfig
make prepare
make -j$(nproc)

sudo make modules_install
sudo make install
cd ..

ls /lib/modules/6.18.5
sudo dracut --force
