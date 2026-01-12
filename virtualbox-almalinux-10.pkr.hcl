variable "hcp_client_id" {
  type    = string
}

variable "hcp_client_secret" {
  type    = string
}

source "virtualbox-iso" "almalinux-10" {
  vm_name       = "packer-almalinux-10"
  guest_os_type = "RedHat10_64"
  firmware      = "efi"
  headless      = true

  iso_url      = "https://repo.almalinux.org/almalinux/10/isos/x86_64/AlmaLinux-10.1-x86_64-boot.iso"
  iso_checksum = "file:https://repo.almalinux.org/almalinux/10/isos/x86_64/CHECKSUM"

  http_directory = "./http"
  boot_wait      = "1s"

  boot_command = [
    "e<down><down><end><bs><bs><bs><bs><bs>",
    "inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/almalinux_10_ks.cfg",
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
  sources = ["source.virtualbox-iso.almalinux-10"]

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
    expect_disconnect = true
  }
  
  post-processors {
    post-processor "vagrant" {
      output = "./boxes/almalinux10-virtualbox.box"
    }

    post-processor "vagrant-registry" {
      box_tag = "imoukafih/almalinux10"
      version = "1.0.0"
      client_id     = "${var.hcp_client_id}"
      client_secret = "${var.hcp_client_secret}"
      
      architecture = "amd64"
    }
  }
}
