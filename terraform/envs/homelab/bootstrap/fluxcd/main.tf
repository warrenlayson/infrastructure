terraform {
  required_version = ">= 0.13"
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "1.5.1"
    }
  }
}

resource "flux_bootstrap_git" "this" {
  embedded_manifests = true
  path               = var.cluster_path
}
