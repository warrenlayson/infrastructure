resource "local_file" "machine_configs" {
  for_each        = module.talos.machine_config
  content         = each.value.machine_configuration
  filename        = "${path.module}/outputs/machine_configs/${each.key}.yaml"
  file_permission = "0600"
}

resource "local_file" "talos_config" {
  content         = module.talos.client_configuration.talos_config
  filename        = "${path.module}/outputs/talos.yaml"
  file_permission = "0600"
}

resource "local_file" "kube_config" {
  content         = module.talos.kube_config.kubeconfig_raw
  filename        = "${path.module}/outputs/kubeconfig.yaml"
  file_permission = "0600"
}

resource "local_file" "kube_ca_cert" {
  content_base64 = module.talos.kube_config.kubernetes_client_configuration.ca_certificate
  filename       = "${path.module}/outputs/kube-ca.crt"
}

output "kube_config" {
  value     = module.talos.kube_config
  sensitive = true
}

output "talos_config" {
  value     = module.talos.client_configuration.talos_config
  sensitive = true
}

output "vault_auth_secret" {
  value     = module.vault.vault_auth_secret
  sensitive = true
}

output "vault-issuer-serviceaccount" {
  value = module.cert_manager.vault-issuer-serviceaccount
}
