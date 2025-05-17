terraform {
  required_version = ">= 0.13"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
  }
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
