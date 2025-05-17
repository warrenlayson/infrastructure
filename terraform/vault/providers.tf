terraform {
  required_version = ">= 1.11.4"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.8.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
  }
}

provider "vault" {
  # Configuration options
}
