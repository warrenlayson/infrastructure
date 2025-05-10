terraform {
  required_version = ">= 0.13"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
  }
}

provider "github" {
  token = var.github_pat
}

data "terraform_remote_state" "github" {
  backend = "local"
  config = {
    path = "../github/terraform.tfstate"
  }
}

resource "tls_private_key" "flux_ssh_key" {
  algorithm = "ED25519"
}

resource "github_repository_deploy_key" "infra_repository_deploy_key" {
  title      = "FluxCD deploy key"
  repository = data.terraform_remote_state.github.outputs.infrastructure_repo.name
  key        = tls_private_key.flux_ssh_key.public_key_openssh
  read_only  = false
}

output "flux_ssh_key" {
  value     = tls_private_key.flux_ssh_key
  sensitive = true
}
