Install Packer
=======
```bash
# For debian
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer

# For Red hat 
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install packer

packer version
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
packer build .
```

### Vagrant
```bash
vagrant box add --name rockylinux-9 ./boxes/rockylinux-9.box --force
vagrant box add --name rockylinux-10 ./boxes/rockylinux-10.box --force
vagrant init rockylinux-9

vagrant destroy -f
vagrant up --provision --provider=virtualbox
```

### Autoinstall
```bash
sudo snap install autoinstall-generator
autoinstall-generator.py -c preseed.cfg autoinstall.yaml
```

### guest_os_type
```bash
VBoxManage list ostypes
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