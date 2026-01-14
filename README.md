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

Install Vagrant 
=======
```bash
## For Debian/Ubuntu
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install vagrant

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
sudo apt install pipx sshpass
pipx install ansible-core==2.20
pipx install --include-deps ansible --force
pipx ensurepath
pipx inject ansible requests
pipx upgrade --include-injected ansible
ansible --version
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

## For RHEL/CentOS
wget https://download.virtualbox.org/virtualbox/7.2.4/VirtualBox-7.2-7.2.4_170995_el10-1.x86_64.rpm

##
VBoxManage --version

## Error fix: Stderr: VBoxManage: error: VT-x is being used by another hypervisor (VERR_VMX_IN_VMX_ROOT_MODE).
sudo modprobe -r kvm_intel kvm

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

packer build -only=qemu.almalinux9_vagrant_libvirt_x86_64 -var-file=hcp.pkrvars.hcl ./almalinux9.pkr.hcl
packer build -only=qemu.almalinux10_vagrant_libvirt_x86_64 -var-file=hcp.pkrvars.hcl ./almalinux10.pkr.hcl
packer build -only=qemu.centos9s_vagrant_libvirt_x86_64 -var-file=hcp.pkrvars.hcl ./centos9s.pkr.hcl
packer build -only=qemu.centos10s_vagrant_libvirt_x86_64 -var-file=hcp.pkrvars.hcl ./centos10s.pkr.hcl
packer build -only=qemu.rockylinux9_vagrant_libvirt_x86_64 -var-file=hcp.pkrvars.hcl ./rockylinux9.pkr.hcl
packer build -only=qemu.rockylinux10_vagrant_libvirt_x86_64 -var-file=hcp.pkrvars.hcl ./rockylinux10.pkr.hcl

```

### Vagrant
```bash
vagrant box add --name almalinux9 ./boxes/almalinux9-virtualbox.box --force

vagrant init almalinux9

vagrant destroy -f
vagrant up --provision --provider=virtualbox
vagrant ssh-config
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
```