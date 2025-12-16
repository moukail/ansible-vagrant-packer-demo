Install Packer
=======
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer

packer version
```

### packer plugins
```bash
packer plugins install github.com/hashicorp/ansible
packer plugins install github.com/hashicorp/vagrant
packer plugins install github.com/hashicorp/virtualbox

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
