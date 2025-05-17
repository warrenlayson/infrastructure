resource "vault_mount" "pki" {
  path                      = "pki"
  type                      = "pki"
  description               = "PKI secret engine mount"
  default_lease_ttl_seconds = 60 * 60 * 24   # 24h
  max_lease_ttl_seconds     = 60 * 60 * 8760 # 8760h
}

resource "vault_pki_secret_backend_root_cert" "root_2025" {
  depends_on  = [vault_mount.pki]
  backend     = vault_mount.pki.path
  type        = "internal"
  common_name = "warrenlayson.xyz"
  ttl         = tostring(vault_mount.pki.max_lease_ttl_seconds)
  issuer_name = "root-2025"
}

resource "vault_pki_secret_backend_issuer" "root_2025" {
  backend                        = vault_mount.pki.path
  issuer_ref                     = vault_pki_secret_backend_root_cert.root_2025.issuer_id
  issuer_name                    = vault_pki_secret_backend_root_cert.root_2025.issuer_name
  revocation_signature_algorithm = "SHA256WithRSA"
}

resource "vault_pki_secret_backend_role" "role" {
  backend          = vault_mount.pki.path
  name             = "2025-servers"
  ttl              = 60 * 60 * 24
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = ["warrenlayson.xyz"]
  allow_subdomains = true
  allow_any_name   = true
}

resource "vault_pki_secret_backend_config_urls" "config-urls" {
  backend                 = vault_mount.pki.path
  issuing_certificates    = ["http://192.168.0.60:8200/v1/pki/ca"]
  crl_distribution_points = ["http://192.168.0.60:8200/v1/pki/crl"]
}

resource "vault_mount" "pki_int" {
  path                      = "pki_int"
  type                      = "pki"
  description               = "This is an example intermediate PKI mount"
  default_lease_ttl_seconds = 60 * 60 * 24
  max_lease_ttl_seconds     = 60 * 60 * 43800
}

resource "vault_pki_secret_backend_intermediate_cert_request" "csr-request" {
  backend     = vault_mount.pki_int.path
  type        = "internal"
  common_name = "warrenlayson.xyz Intermediate Authority"
}

resource "local_file" "csr_request_cert" {
  content  = vault_pki_secret_backend_intermediate_cert_request.csr-request.csr
  filename = "outputs/pki_intermediate.csr"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "intermediate" {
  backend     = vault_mount.pki.path
  common_name = "new_intermediate"
  csr         = vault_pki_secret_backend_intermediate_cert_request.csr-request.csr
  format      = "pem_bundle"
  ttl         = 60 * 60 * 4300
  issuer_ref  = vault_pki_secret_backend_root_cert.root_2025.issuer_id
}

resource "local_file" "intermediate_ca_cert" {
  content  = vault_pki_secret_backend_root_sign_intermediate.intermediate.certificate
  filename = "outputs/intermediate.cert.pem"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate" {
  backend     = vault_mount.pki_int.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.intermediate.certificate
}

# manage the issuer created for the set signed
resource "vault_pki_secret_backend_issuer" "intermediate" {
  backend     = vault_mount.pki_int.path
  issuer_ref  = vault_pki_secret_backend_intermediate_set_signed.intermediate.imported_issuers[0]
  issuer_name = "warrenlayson-dot-xyz-intermediate"
}

resource "vault_pki_secret_backend_role" "intermediate_role" {
  backend          = vault_mount.pki_int.path
  issuer_ref       = vault_pki_secret_backend_issuer.intermediate.issuer_ref
  name             = "warrenlayson-dot-xyz"
  ttl              = 86400
  max_ttl          = 2592000
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = ["warrenlayson.xyz"]
  allow_subdomains = true
}



resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = data.terraform_remote_state.kubernetes.outputs.kube_config.kubernetes_client_configuration.host
  kubernetes_ca_cert = base64decode(data.terraform_remote_state.kubernetes.outputs.kube_config.kubernetes_client_configuration.ca_certificate)

  token_reviewer_jwt = data.terraform_remote_state.kubernetes.outputs.vault_auth_secret.data.token
}

resource "vault_kubernetes_auth_backend_role" "issuer" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "issuer"
  bound_service_account_names      = [data.terraform_remote_state.kubernetes.outputs.issuer_service_account.metadata[0].name]
  bound_service_account_namespaces = [data.terraform_remote_state.kubernetes.outputs.issuer_service_account.metadata[0].namespace]
  token_policies                   = [vault_policy.pki.name]
  token_ttl                        = 60 * 20
}
