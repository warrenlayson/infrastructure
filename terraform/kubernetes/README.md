<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 1.5.1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.5.2 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 0.77.1 |
| <a name="requirement_talos"></a> [talos](#requirement\_talos) | 0.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_talos"></a> [talos](#module\_talos) | ./modules/talos | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.kube_config](https://registry.terraform.io/providers/hashicorp/local/2.5.2/docs/resources/file) | resource |
| [local_file.machine_configs](https://registry.terraform.io/providers/hashicorp/local/2.5.2/docs/resources/file) | resource |
| [local_file.talos_config](https://registry.terraform.io/providers/hashicorp/local/2.5.2/docs/resources/file) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | n/a |
| <a name="output_talos_config"></a> [talos\_config](#output\_talos\_config) | n/a |
<!-- END_TF_DOCS -->