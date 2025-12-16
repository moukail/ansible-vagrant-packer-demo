source "virtualbox-iso" "centos-10" {
  vm_name       = "packer-centos-10"
  guest_os_type = "RedHat10_64"
  firmware      = "efi"
  headless      = true

  iso_url      = "https://mirror.i3d.net/pub/centos-stream/10-stream/BaseOS/x86_64/iso/CentOS-Stream-10-latest-x86_64-boot.iso"
  iso_checksum = "sha256:66ac4bfca2b5d45a634dcdd0b02d3ae3df01cd5fb4ddd96e4234053590d82cfc"

  http_directory = "./http"
  boot_wait      = "1s"

  boot_command = [
    "e<down><down><end><bs><bs><bs><bs><bs>",
    "inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos_10_ks.cfg",
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
  sources = ["source.virtualbox-iso.centos-10"]

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
    output = "./boxes/centos-10.box"
  }
}
