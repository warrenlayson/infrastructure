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

    flux = {
      source  = "fluxcd/flux"
      version = "1.5.1"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
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
locals {
  kubernetes_config = {
    host                   = module.talos.kube_config.kubernetes_client_configuration.host
    client_certificate     = base64decode(module.talos.kube_config.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(module.talos.kube_config.kubernetes_client_configuration.client_key)
    cluster_ca_certificate = base64decode(module.talos.kube_config.kubernetes_client_configuration.ca_certificate)
  }
}

provider "kubernetes" {
  host                   = local.kubernetes_config.host
  client_certificate     = local.kubernetes_config.client_certificate
  client_key             = local.kubernetes_config.client_key
  cluster_ca_certificate = local.kubernetes_config.cluster_ca_certificate
}

provider "flux" {
  kubernetes = local.kubernetes_config
  git = {
    url = "ssh://git@github.com/${var.github_org}/${var.github_repository}.git"
    ssh = {
      username    = "git"
      private_key = data.terraform_remote_state.keypairs.outputs.flux_ssh_key.private_key_pem
    }
  }
}
