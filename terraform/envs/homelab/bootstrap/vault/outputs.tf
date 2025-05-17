output "vault_auth_secret" {
  value     = kubernetes_secret_v1.vault-auth
  sensitive = true
}
