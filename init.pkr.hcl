packer {
  required_plugins {
    virtualbox = {
      version = "~> 1.0"
      source  = "github.com/hashicorp/virtualbox"
    }
    vagrant = {
      version = "~> 1.0"
      source  = "github.com/hashicorp/vagrant"
    }
    ansible = {
      version = "~> 1.0"
      source  = "github.com/hashicorp/ansible"
    }
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}
