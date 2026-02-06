variable "hcp_client_id" {
  type    = string
  default = "${env("HCP_CLIENT_ID")}"
}

variable "hcp_client_secret" {
  type    = string
  default = "${env("HCP_CLIENT_SECRET")}"
}

source "virtualbox-iso" "ubuntu2404_vagrant_x86_64" {
  vm_name       = "ubuntu2404_vagrant"
  guest_os_type = "Ubuntu_64"
  headless      = false

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
  sources = ["source.virtualbox-iso.ubuntu2404_vagrant_x86_64"]

  provisioner "shell" {
    script = "scripts/ssh.sh"
    expect_disconnect = true
  }

  post-processors {
    post-processor "vagrant" {
      compression_level = "9"
      output = "./boxes/ubuntu2404-vagrant-{{.Provider}}.box"
    }

    #post-processor "vagrant-registry" {
    #  box_tag = "imoukafih/ubuntu24.04"
    #  version = "1.0.0"
    #  client_id     = "${var.hcp_client_id}"
    #  client_secret = "${var.hcp_client_secret}"
      
    #  architecture = "amd64"
    #}
  }
}
