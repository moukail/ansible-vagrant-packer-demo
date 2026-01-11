source "virtualbox-iso" "ubuntu-24-04" {
  vm_name       = "ubuntu-24.04-vagrant"
  guest_os_type = "Ubuntu_64"
  headless      = true

  iso_url      = "https://releases.ubuntu.com/24.04/ubuntu-24.04.3-live-server-amd64.iso"
  iso_checksum = "file:https://releases.ubuntu.com/24.04/SHA256SUMS"

  http_directory  = "./http"

  boot_wait       = "3s"

  boot_command    = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu/\"<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter><wait>"
  ]

  ssh_username = "vagrant"
  ssh_password = "vagrant"
  ssh_timeout  = "30m"

  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"

  disk_size = 20000
  cpus      = 2
  memory    = 2048
}

build {
  sources = ["source.virtualbox-iso.ubuntu-24-04"]

  provisioner "ansible" {
    playbook_file = "./ansible/playbook.yml"
  }

  provisioner "shell" {
    script = "scripts/virtualbox.sh"
    #expect_disconnect = true
  }

  post-processor "vagrant" {
    output = "boxes/ubuntu-24.04.box"
  }
}
