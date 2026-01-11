source "virtualbox-iso" "almalinux-9" {
  vm_name       = "packer-almalinux-9"
  guest_os_type = "RedHat10_64"
  firmware      = "efi"
  headless      = true

  iso_url      = "https://repo.almalinux.org/almalinux/9/isos/x86_64/AlmaLinux-9.7-x86_64-boot.iso"
  iso_checksum = "sha256:494d09f608b325ef42899b5ce38ba1b17755a639f5558b9b98a031b0696e694a"

  http_directory = "./http"
  boot_wait      = "1s"

  boot_command = [
    "e<down><down><end><bs><bs><bs><bs><bs>",
    "inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/almalinux_9_ks.cfg",
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
  sources = ["source.virtualbox-iso.almalinux-9"]

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
    output = "./boxes/almalinux-9.box"
  }
}
