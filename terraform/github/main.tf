terraform {
  required_version = ">= 0.13"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
  token = var.github_pat
}

resource "github_repository" "infrastructure" {
  name = "infrastructure"
}

resource "github_branch" "infrastructure" {
  repository = github_repository.infrastructure.name
  branch     = "main"
}

output "infrastructure_repo" {
  value = github_repository.infrastructure
}
