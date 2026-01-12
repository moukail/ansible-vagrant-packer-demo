variable "hcp_client_id" {
  type    = string
  default = "${env("HCP_CLIENT_ID")}"
}

variable "hcp_client_secret" {
  type    = string
  default = "${env("HCP_CLIENT_SECRET")}"
}

source "virtualbox-iso" "centos-10" {
  vm_name       = "packer-centos-10"
  guest_os_type = "RedHat10_64"
  firmware      = "efi"
  headless      = true

  iso_url      = "https://mirror.stream.centos.org/10-stream/BaseOS/x86_64/iso/CentOS-Stream-10-latest-x86_64-boot.iso"
  iso_checksum = "file:https://mirror.stream.centos.org/10-stream/BaseOS/x86_64/iso/CentOS-Stream-10-latest-x86_64-boot.iso.SHA256SUM"

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
    script = "scripts/virtualbox.sh"
  }

  post-processors {
    post-processor "vagrant" {
      output = "./boxes/centos-stream10-virtualbox.box"
    }

    post-processor "vagrant-registry" {
      box_tag = "imoukafih/centos10s"
      version = "1.0.0"
      client_id     = "${var.hcp_client_id}"
      client_secret = "${var.hcp_client_secret}"
      
      architecture = "amd64"
    }
  }
}
