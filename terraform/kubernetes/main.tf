
module "talos" {
  source = "./modules/talos"
  providers = {
    proxmox = proxmox
    talos   = talos
  }
  nodes = {
    "talos-00" = {
      machine_type = "controlplane"
      ip           = "192.168.0.200"
      host_node    = "pve1"
      vm_id        = 800
      cpu          = 4
      memory       = 1024 * 4
    }
    "work-00" = {
      machine_type = "worker"
      ip           = "192.168.0.210"
      host_node    = "pve1"
      vm_id        = 810
      cpu          = 4
      memory       = 1024 * 4
    }
  }

  cluster = {
    name          = "talos"
    endpoint      = "192.168.0.200"
    gateway       = "192.168.0.1"
    talos_version = "v1.10.0"
  }
}

resource "flux_bootstrap_git" "this" {
  depends_on         = [module.talos]
  embedded_manifests = true
  path               = "clusters/homelab"
}
