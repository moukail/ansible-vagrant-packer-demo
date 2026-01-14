variable "iso_url" {
  type    = string
  default = "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.7-x86_64-boot.iso"
}

variable "iso_checksum" {
  type    = string
  default = "file:https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.7-x86_64-boot.iso.CHECKSUM"
}

variable "hcp_client_id" {
  type    = string
  default = "${env("HCP_CLIENT_ID")}"
}

variable "hcp_client_secret" {
  type    = string
  default = "${env("HCP_CLIENT_SECRET")}"
}

source "qemu" "rockylinux9_vagrant_libvirt_x86_64" {
  vm_name       = "packer_rockylinux9_vagrant_libvirt_x86_64"
  accelerator   = "kvm"
  format        = "qcow2"
  headless      = true

  disk_interface   = "virtio"
  disk_size  = "20000"
  disk_cache = "none"
  disk_compression = true

  qemuargs = [
    ["-m", "2048M"], ["-smp", "2"], ["-cpu", "host"],
  ]

  iso_url      = "${var.iso_url}"
  iso_checksum = "${var.iso_checksum}"

  http_directory = "./http"
  boot_wait      = "5s"

  boot_command = [
    "<tab><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux9_ks.cfg",
    "<enter><wait>"
  ]

  ssh_username = "vagrant"
  ssh_password = "vagrant"
  ssh_timeout  = "30m"

  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
}

source "virtualbox-iso" "rockylinux9_vagrant_virtualbox_x86_64" {
  vm_name       = "packer_rockylinux9_vagrant_virtualbox_x86_64"
  guest_os_type = "RedHat_64"
  firmware      = "efi"
  headless      = true

  iso_url      = "${var.iso_url}"
  iso_checksum = "${var.iso_checksum}"

  http_directory = "./http"
  boot_wait      = "1s"

  boot_command = [
    "e<down><down><end><bs><bs><bs><bs><bs>",
    "inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux9_ks.cfg",
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
  sources = [
    "qemu.rockylinux9_vagrant_libvirt_x86_64",
    "virtualbox-iso.rockylinux9_vagrant_virtualbox_x86_64"
  ]

  #provisioner "shell" {
  #  script = "scripts/virtualbox.sh"
  #  expect_disconnect = true
  #}

  provisioner "ansible" {
    playbook_file        = "./ansible/playbook.yml"
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true
    #collections_path     = "./ansible/collections"
    #roles_path           = "./ansible/roles"
    user                 = "vagrant"
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
    ]
  }

  post-processors {
    post-processor "vagrant" {
      compression_level = "9"
      output = "./boxes/rockylinux9-vagrant-{{.Provider}}.box"
    }

    post-processor "vagrant-registry" {
      box_tag = "imoukafih/rockylinux9"
      version = "1.0.0"
      client_id     = "${var.hcp_client_id}"
      client_secret = "${var.hcp_client_secret}"
      
      architecture = "amd64"
    }
  }
}
