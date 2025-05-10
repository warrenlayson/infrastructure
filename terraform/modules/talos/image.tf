locals {
  version      = var.cluster.talos_version
  schematic_id = talos_image_factory_schematic.this.id
  image_id     = "${local.schematic_id}_${local.version}"
}

data "talos_image_factory_extensions_versions" "this" {
  # get the latest talos version
  talos_version = local.version
  filters = {
    names = [
      "qemu-guest-agent",
      "iscsi-tools"
    ]
  }
}

resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode({
    customization = {
      systemExtensions = {
        officialExtensions = data.talos_image_factory_extensions_versions.this.extensions_info[*].name
      }
    }
  })
}

data "talos_image_factory_urls" "this" {
  talos_version = local.version
  schematic_id  = talos_image_factory_schematic.this.id
  platform      = var.image.platform
  architecture  = var.image.arch
}

resource "proxmox_virtual_environment_download_file" "this" {
  for_each     = toset(distinct([for k, v in var.nodes : v.host_node]))
  node_name    = each.key
  content_type = "iso"
  datastore_id = var.image.proxmox_datastore
  url          = data.talos_image_factory_urls.this.urls.iso
  file_name    = "talos-${local.image_id}-${var.image.platform}-${var.image.arch}.iso"
  overwrite    = false
}
