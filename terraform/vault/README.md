<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.4 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | 4.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 4.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_mount.pki](https://registry.terraform.io/providers/hashicorp/vault/4.8.0/docs/resources/mount) | resource |
| [vault_mount.pki_int](https://registry.terraform.io/providers/hashicorp/vault/4.8.0/docs/resources/mount) | resource |
| [vault_pki_secret_backend_config_urls.config-urls](https://registry.terraform.io/providers/hashicorp/vault/4.8.0/docs/resources/pki_secret_backend_config_urls) | resource |
| [vault_pki_secret_backend_intermediate_cert_request.csr-request](https://registry.terraform.io/providers/hashicorp/vault/4.8.0/docs/resources/pki_secret_backend_intermediate_cert_request) | resource |
| [vault_pki_secret_backend_intermediate_set_signed.intermediate](https://registry.terraform.io/providers/hashicorp/vault/4.8.0/docs/resources/pki_secret_backend_intermediate_set_signed) | resource |
| [vault_pki_secret_backend_issuer.root_2025](https://registry.terraform.io/providers/hashicorp/vault/4.8.0/docs/resources/pki_secret_backend_issuer) | resource |
| [vault_pki_secret_backend_role.role](https://registry.terraform.io/providers/hashicorp/vault/4.8.0/docs/resources/pki_secret_backend_role) | resource |
| [vault_pki_secret_backend_root_cert.root_2025](https://registry.terraform.io/providers/hashicorp/vault/4.8.0/docs/resources/pki_secret_backend_root_cert) | resource |
| [vault_pki_secret_backend_root_sign_intermediate.intermediate](https://registry.terraform.io/providers/hashicorp/vault/4.8.0/docs/resources/pki_secret_backend_root_sign_intermediate) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->