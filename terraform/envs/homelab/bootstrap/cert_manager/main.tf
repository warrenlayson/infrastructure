terraform {
  required_version = ">= 0.13"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
  }
}

resource "kubernetes_service_account_v1" "vault-issuer" {
  metadata {
    name      = "vault-issuer"
    namespace = "cert-manager"
  }
}

resource "kubernetes_secret_v1" "vault-issuer" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.vault-issuer.metadata[0].name
    }
    name      = "cluster-issuer-token"
    namespace = kubernetes_service_account_v1.vault-issuer.metadata[0].namespace
  }
  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}

resource "kubernetes_cluster_role_v1" "vault-issuer" {
  metadata {
    name = kubernetes_service_account_v1.vault-issuer.metadata[0].name
  }
  rule {
    api_groups     = [""]
    resources      = ["serviceaccounts/token"]
    resource_names = ["vault-issuer"]
    verbs          = ["create"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "vault-issuer" {
  metadata {
    name = kubernetes_service_account_v1.vault-issuer.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "cert-manager"
    namespace = "cert-manager"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.vault-issuer.metadata[0].name
  }
}
