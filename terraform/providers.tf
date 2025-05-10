terraform {
  required_version = ">= 0.13"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.77.1"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.8.0"
    }
  }
}

provider "proxmox" {
  tmp_dir = "/var/tmp"
  ssh {
    agent = true

    node {
      name    = "pve1"
      address = "192.168.0.10"
    }
  }
}

provider "talos" {

}
