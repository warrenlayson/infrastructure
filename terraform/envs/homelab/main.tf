
module "talos" {
  source = "../../modules/talos"
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

module "fluxcd" {
  depends_on = [module.talos]
  source     = "./bootstrap/fluxcd"
  providers = {
    flux = flux
  }
  cluster_path = "clusters/homelab"
}

moved {
  from = flux_bootstrap_git.this
  to   = module.fluxcd.flux_bootstrap_git.this
}


module "vault" {
  depends_on = [module.talos]
  source     = "./bootstrap/vault"
  providers = {
    kubernetes = kubernetes
  }
}

moved {
  from = kubernetes_service_account_v1.vault-auth
  to   = module.vault.kubernetes_service_account_v1.vault-auth
}

moved {
  from = kubernetes_cluster_role_binding_v1.role-tokenreview-binding
  to   = module.vault.kubernetes_cluster_role_binding_v1.role-tokenreview-binding
}

moved {
  from = kubernetes_secret_v1.vault-auth
  to   = module.vault.kubernetes_secret_v1.vault-auth
}


module "cert_manager" {
  depends_on = [module.talos]
  source     = "./bootstrap/cert_manager"
  providers = {
    kubernetes = kubernetes
  }
}

moved {
  from = kubernetes_service_account_v1.vault-issuer
  to   = module.cert_manager.kubernetes_service_account_v1.vault-issuer
}

moved {
  from = kubernetes_secret_v1.vault-issuer
  to   = module.cert_manager.kubernetes_secret_v1.vault-issuer
}

moved {
  from = kubernetes_cluster_role_v1.vault-issuer
  to   = module.cert_manager.kubernetes_cluster_role_v1.vault-issuer
}

moved {
  from = kubernetes_cluster_role_binding_v1.vault-issuer
  to   = module.cert_manager.kubernetes_cluster_role_binding_v1.vault-issuer
}
