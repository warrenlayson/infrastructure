resource "proxmox_virtual_environment_vm" "this" {
  for_each    = var.nodes
  description = "Managed by Terraform"
  tags        = ["terraform", "talos"]
  node_name   = each.value.host_node
  vm_id       = each.value.vm_id
  name        = each.key

  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"
  bios          = "seabios"

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cpu
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
    floating  = each.value.memory
  }
  disk {
    datastore_id = each.value.datastore_id
    interface    = "scsi0"
    iothread     = true
    cache        = "writethrough"
    discard      = "on"
    ssd          = true
    size         = 10
  }

  cdrom {
    file_id = proxmox_virtual_environment_download_file.this[each.value.host_node].id
  }

  initialization {
    datastore_id = each.value.datastore_id
    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = var.cluster.gateway
      }
    }
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }
}
