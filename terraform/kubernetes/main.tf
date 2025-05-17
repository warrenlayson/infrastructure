
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

resource "kubernetes_service_account_v1" "vault-auth" {
  metadata {
    name = "vault-auth"
  }
}

resource "kubernetes_cluster_role_binding_v1" "role-tokenreview-binding" {
  metadata {
    name = "role-tokenreview-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account_v1.vault-auth.metadata[0].name
  }
}

resource "kubernetes_secret_v1" "vault-auth" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.vault-auth.metadata[0].name
    }
    generate_name = "vault-auth-"
  }

  type = "kubernetes.io/service-account-token"
}
