locals {
  machine_config_patch = {
    for k, v in var.nodes : k => templatefile("${path.module}/files/machine-config-patch.yml.tftpl", {
      image        = data.talos_image_factory_urls.this.urls.installer
      hostname     = k
      node_name    = v.host_node
      cluster_name = var.cluster.name
    })
  }

  cilium_patch = templatefile("${path.module}/files/cluster-patch.yml.tftpl", {
    cilium_values  = file("${path.module}/files/cilium-values.yml"),
    cilium_install = file("${path.module}/files/cilium-install.yml")
  })
}

resource "talos_machine_secrets" "this" {
  talos_version = local.version
}

data "talos_machine_configuration" "this" {
  for_each         = var.nodes
  talos_version    = local.version
  cluster_name     = var.cluster.name
  machine_type     = each.value.machine_type
  cluster_endpoint = "https://${var.cluster.endpoint}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster.name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [for k, v in var.nodes : v.ip]
  endpoints            = [for k, v in var.nodes : v.ip if v.machine_type == "controlplane"]
}

resource "talos_machine_configuration_apply" "this" {
  depends_on                  = [proxmox_virtual_environment_vm.this]
  for_each                    = var.nodes
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  node                        = each.key
  endpoint                    = each.value.ip
  config_patches = each.value.machine_type == "controlplane" ? [
    local.machine_config_patch[each.key],
    local.cilium_patch
    ] : [
    local.machine_config_patch[each.key]
  ]
  lifecycle {
    replace_triggered_by = [proxmox_virtual_environment_vm.this[each.key]]
  }
}

resource "talos_machine_bootstrap" "this" {
  node                 = [for k, v in var.nodes : v.ip if v.machine_type == "controlplane"][0]
  depends_on           = [proxmox_virtual_environment_vm.this, talos_machine_configuration_apply.this]
  endpoint             = var.cluster.endpoint
  client_configuration = talos_machine_secrets.this.client_configuration
}

data "talos_cluster_health" "this" {
  count                = 1
  depends_on           = [talos_machine_configuration_apply.this, talos_machine_bootstrap.this]
  client_configuration = data.talos_client_configuration.this.client_configuration
  control_plane_nodes  = [for k, v in var.nodes : v.ip if v.machine_type == "controlplane"]
  worker_nodes         = [for k, v in var.nodes : v.ip if v.machine_type == "worker"]
  endpoints            = data.talos_client_configuration.this.endpoints
  timeouts = {
    read = "10m"
  }
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this, data.talos_cluster_health.this]
  node                 = [for k, v in var.nodes : v.ip if v.machine_type == "controlplane"][0]
  endpoint             = var.cluster.endpoint
  client_configuration = talos_machine_secrets.this.client_configuration
  timeouts = {
    read = "1m"
  }
}

