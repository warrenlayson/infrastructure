<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.36.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.36.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role_binding_v1.role-tokenreview-binding](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/cluster_role_binding_v1) | resource |
| [kubernetes_secret_v1.vault-auth](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/secret_v1) | resource |
| [kubernetes_service_account_v1.vault-auth](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/service_account_v1) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vault_auth_secret"></a> [vault\_auth\_secret](#output\_vault\_auth\_secret) | n/a |
<!-- END_TF_DOCS -->