variable "hcp_client_id" {
  type    = string
  default = "${env("HCP_CLIENT_ID")}"
}

variable "hcp_client_secret" {
  type    = string
  default = "${env("HCP_CLIENT_SECRET")}"
}

source "qemu" "centos-9" {
  vm_name       = "packer-centos-9"
  accelerator   = "kvm"
  format        = "qcow2"
  headless      = true
  #net_device    = "virtio-net"

  disk_interface   = "virtio"
  disk_size  = "20000"
  disk_cache = "none"
  disk_compression = true

  qemuargs = [
    ["-m", "2048M"], ["-smp", "2"], ["-cpu", "host"],
  ]

  iso_url      = "https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-boot.iso"
  iso_checksum = "file:https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-boot.iso.SHA256SUM"

  http_directory = "./http"
  boot_wait      = "5s"

  boot_command = [
    "<tab><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos_9_ks.cfg",
    "<enter><wait>"
  ]

  ssh_username = "vagrant"
  ssh_password = "vagrant"
  ssh_timeout  = "30m"

  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
}

build {
  sources = ["source.qemu.centos-9"]

  provisioner "ansible" {
    playbook_file = "./ansible/playbook.yml"
    user          = "vagrant"
    use_proxy     = true
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
    ]
  }
  
  post-processors {
    post-processor "vagrant" {
      output = "./boxes/centos-stream9-libvirt.box"
    }

    post-processor "vagrant-registry" {
      box_tag = "imoukafih/centos9s"
      version = "1.0.0"
      client_id     = "${var.hcp_client_id}"
      client_secret = "${var.hcp_client_secret}"
      
      architecture = "amd64"
    }
  }
}
