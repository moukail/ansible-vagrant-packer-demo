Install Packer
=======
```bash
## For Debian/Ubuntu
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer

## For RHEL/CentOS
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install packer

packer version
```

Install QEMU
======
```bash
## For Debian/Ubuntu
sudo apt install -y qemu-system libvirt-daemon-system libvirt-dev

sudo usermod -aG libvirt,kvm $USER
newgrp libvirt
sudo systemctl enable --now libvirtd

## For RHEL/CentOS
sudo yum install qemu-kvm

sudo modprobe kvm_intel || true
```

Install VirtualBox
======
```bash
## For Ubuntu
sudo apt install make gcc liblzf1 libtpms0 libxcb-cursor0

wget https://download.virtualbox.org/virtualbox/7.2.4/virtualbox-7.2_7.2.4-170995~Ubuntu~noble_amd64.deb
sudo dpkg -i virtualbox-7.2_7.2.4-170995~Ubuntu~noble_amd64.deb
sudo /sbin/vboxconfig

## To build centos vagrant box you need virtualbox-7.1
sudo apt install libqt6core6t64 libqt6dbus6t64 libqt6gui6t64 libqt6help6 libqt6printsupport6t64 libqt6statemachine6 libqt6widgets6t64 libqt6xml6t64

wget https://download.virtualbox.org/virtualbox/7.1.14/virtualbox-7.1_7.1.14-170994~Ubuntu~noble_amd64.deb
sudo dpkg -i virtualbox-7.1_7.1.14-170994~Ubuntu~noble_amd64.deb

## For RHEL/CentOS
wget https://download.virtualbox.org/virtualbox/7.2.4/VirtualBox-7.2-7.2.4_170995_el10-1.x86_64.rpm
sudo dnf install VirtualBox-7.2-7.2.4_170995_el10-1.x86_64.rpm

##
VBoxManage --version

## Error fix: Stderr: VBoxManage: error: VT-x is being used by another hypervisor (VERR_VMX_IN_VMX_ROOT_MODE).
sudo modprobe -r kvm_intel kvm

## Error fix: Stderr: /sbin/vboxconfig: error: The VirtualBox kernel module is not loaded.
sudo dnf install -y gcc make perl kernel-devel-$(uname -r)
sudo /sbin/vboxconfig
```

Install Vagrant
=======
```bash
## For Debian/Ubuntu
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install vagrant

## For RHEL/CentOS
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install vagrant

vagrant plugin install vagrant-libvirt
vagrant plugin install vagrant-vbguest
vagrant reload
```

Install Ansible
=======
```bash
## using pip
sudo apt install python3-pip
pip install ansible

## using pipx
### For Debian/Ubuntu
sudo apt install pipx sshpass

### For RHEL/CentOS
sudo dnf install python3-pip
python3 -m pip install --user pipx

### For both Debian/Ubuntu and RHEL/CentOS
pipx install ansible-core==2.20
pipx install --include-deps ansible --force
pipx ensurepath
pipx inject ansible requests
pipx upgrade --include-injected ansible

ansible --version
```

### packer plugins
```bash
packer plugins install github.com/hashicorp/ansible
packer plugins install github.com/hashicorp/vagrant
packer plugins install github.com/hashicorp/virtualbox
packer plugins install github.com/hashicorp/qemu

```
mkpasswd --method=SHA-512
chmod +x scripts/vagrant.sh

### Build
```bash
packer init .

packer build -only=virtualbox-iso.almalinux9_vagrant_x86_64 -var-file=hcp.pkrvars.hcl ./almalinux9.pkr.hcl
packer build -only=virtualbox-iso.almalinux10_vagrant_x86_64 -var-file=hcp.pkrvars.hcl ./almalinux10.pkr.hcl
packer build -only=virtualbox-iso.centos9s_vagrant_x86_64 -var-file=hcp.pkrvars.hcl ./centos9s.pkr.hcl
packer build -only=virtualbox-iso.centos10s_vagrant_x86_64 -var-file=hcp.pkrvars.hcl ./centos10s.pkr.hcl
packer build -only=virtualbox-iso.rockylinux9_vagrant_x86_64 -var-file=hcp.pkrvars.hcl ./rockylinux9.pkr.hcl
packer build -only=virtualbox-iso.rockylinux10_vagrant_x86_64 -var-file=hcp.pkrvars.hcl ./rockylinux10.pkr.hcl

```

### Vagrant
```bash
vagrant box add --name centos9s ./boxes/centos9s-vagrant-libvirt.box --force

vagrant init almalinux9

vagrant destroy -f
vagrant up --provision --provider=virtualbox
vagrant ssh-config

vagrant box remove almalinux9
```

### Autoinstall
```bash
sudo snap install autoinstall-generator
autoinstall-generator.py -c preseed.cfg autoinstall.yaml
```

### guest_os_type
```bash
VBoxManage list ostypes
VBoxManage list runningvms
VBoxManage showvminfo 25431645-3f26-4957-8a90-4cbf6241d5ed

```

###
```bash
wget https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-boot.iso

qemu-img create -f qcow2 disk.qcow2 20G

/usr/libexec/qemu-kvm -enable-kvm -m 2048 -cpu host -smp 2 \
  -drive file=disk.qcow2,format=qcow2 \
  -cdrom ~/Downloads/CentOS-Stream-9-latest-x86_64-boot.iso -boot d \
  -display none -vnc 127.0.0.1:0


wget https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-latest.x86_64.vagrant-virtualbox.box
vagrant box add --name centos9s ./CentOS-Stream-Vagrant-9-latest.x86_64.vagrant-virtualbox.box --force

wget https://cloud.centos.org/centos/10-stream/x86_64/images/CentOS-Stream-Vagrant-10-latest.x86_64.vagrant-virtualbox.box
vagrant box add --name centos10s ./CentOS-Stream-Vagrant-10-latest.x86_64.vagrant-virtualbox.box --force

wget https://distfiles.gentoo.org/releases/amd64/autobuilds/20260114T140056Z/install-amd64-minimal-20260114T140056Z.iso
```