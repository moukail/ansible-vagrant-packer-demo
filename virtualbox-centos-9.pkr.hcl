source "virtualbox-iso" "centos-9" {
  vm_name       = "packer-centos-9"
  guest_os_type = "RedHat9_64"
  firmware      = "efi"
  headless      = true

  iso_url      = "https://mirror.i3d.net/pub/centos-stream/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-boot.iso"
  iso_checksum = "sha256:4262145325c4320bae40c07f083ef944761a68d25fe8c1a42b322498daac195d"

  http_directory = "./http"
  boot_wait      = "1s"

  boot_command = [
    "e<down><down><end><bs><bs><bs><bs><bs>",
    "inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos_9_ks.cfg",
    "<leftCtrlOn>x<leftCtrlOff>"
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
  sources = ["source.virtualbox-iso.centos-9"]

  provisioner "ansible" {
    playbook_file = "./ansible/playbook.yml"
    user          = "vagrant"
    use_proxy     = true
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
    ]
  }

  provisioner "shell" {
    script = "scripts/virtualbox.sh"
    #expect_disconnect = true
  }
  
  post-processor "vagrant" {
    output = "./boxes/centos-9.box"
  }
}
