#!/bin/bash
set -eux

wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.18.5.tar.xz
tar -xf linux-6.18.5.tar.xz
cd linux-6.18.5

make defconfig
make prepare
make -j$(nproc)

sudo make modules_install
sudo make install
cd ..

ls /lib/modules/6.18.5
sudo dracut --force