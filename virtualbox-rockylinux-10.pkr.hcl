source "virtualbox-iso" "rockylinux-10" {
  vm_name       = "packer-rockylinux-10"
  guest_os_type = "RedHat10_64"
  firmware      = "efi"
  headless      = true

  iso_url      = "https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.1-x86_64-boot.iso"
  iso_checksum = "sha256:18543988d9a1a5632d142c3dc288136dcc48ab71628f92ebcd40ada7f4ecd110"

  http_directory = "./http"
  boot_wait      = "1s"

  boot_command = [
    "e<down><down><end><bs><bs><bs><bs><bs>",
    "inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux_10_ks.cfg",
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
  sources = ["source.virtualbox-iso.rockylinux-10"]

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
    output = "./boxes/rockylinux-10.box"
  }
}
