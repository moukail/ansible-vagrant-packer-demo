source "virtualbox-iso" "rockylinux-9" {
  vm_name       = "packer-rockylinux-9"
  guest_os_type = "RedHat9_64"
  firmware      = "efi"
  headless      = true

  #iso_url      = "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.7-x86_64-boot.iso"
  #iso_checksum = "sha256:3b5c87b2f9e62fdf0235d424d64c677906096965aad8a580e0e98fcb9f97f267"

  iso_url      = "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.7-x86_64-minimal.iso"
  iso_checksum = "sha256:23a1ac1175d8ccada7195863914ef1237f584ff25f73bd53da410d5fffd882b0"

  http_directory = "./http"
  boot_wait      = "1s"

  boot_command = [
    "e<down><down><end><bs><bs><bs><bs><bs>",
    "inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux_9_ks.cfg",
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
  sources = ["source.virtualbox-iso.rockylinux-9"]

  provisioner "ansible" {
    playbook_file = "./ansible/playbook.yml"
    user          = "vagrant"
    use_proxy     = true
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
    ]
  }

  provisioner "shell" {
    script = "scripts/vagrant.sh"
    #expect_disconnect = true
  }

  post-processor "vagrant" {
    output = "./boxes/rockylinux-9.box"
  }
}
