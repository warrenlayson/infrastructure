<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 1.5.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.36.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.5.2 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 0.77.1 |
| <a name="requirement_talos"></a> [talos](#requirement\_talos) | 0.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_flux"></a> [flux](#provider\_flux) | 1.5.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.36.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.2 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_talos"></a> [talos](#module\_talos) | ./modules/talos | n/a |

## Resources

| Name | Type |
|------|------|
| [flux_bootstrap_git.this](https://registry.terraform.io/providers/fluxcd/flux/1.5.1/docs/resources/bootstrap_git) | resource |
| [kubernetes_cluster_role_binding_v1.role-tokenreview-binding](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/cluster_role_binding_v1) | resource |
| [kubernetes_secret_v1.issuer](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.vault-auth](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/secret_v1) | resource |
| [kubernetes_service_account_v1.issuer](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/service_account_v1) | resource |
| [kubernetes_service_account_v1.vault-auth](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/service_account_v1) | resource |
| [local_file.kube_config](https://registry.terraform.io/providers/hashicorp/local/2.5.2/docs/resources/file) | resource |
| [local_file.machine_configs](https://registry.terraform.io/providers/hashicorp/local/2.5.2/docs/resources/file) | resource |
| [local_file.talos_config](https://registry.terraform.io/providers/hashicorp/local/2.5.2/docs/resources/file) | resource |
| [terraform_remote_state.keypairs](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | GitHub organization | `string` | `"warrenlayson"` | no |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | GitHub organization | `string` | `"infrastructure"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_issuer_service_account"></a> [issuer\_service\_account](#output\_issuer\_service\_account) | n/a |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | n/a |
| <a name="output_talos_config"></a> [talos\_config](#output\_talos\_config) | n/a |
| <a name="output_vault_auth_secret"></a> [vault\_auth\_secret](#output\_vault\_auth\_secret) | n/a |
<!-- END_TF_DOCS -->