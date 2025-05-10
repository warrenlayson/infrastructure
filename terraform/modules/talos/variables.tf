variable "image" {
  description = "Talos image configuration"
  type = object({
    arch              = optional(string, "amd64")
    platform          = optional(string, "nocloud")
    proxmox_datastore = optional(string, "local")
  })
  default = {

  }
}

variable "cluster" {
  description = "Cluster configuration"
  type = object({
    name          = string
    endpoint      = string
    gateway       = string
    talos_version = string
  })
}

variable "nodes" {
  description = "Configuration for cluster nodes"
  type = map(object({
    host_node    = string,
    machine_type = string,
    datastore_id = optional(string, "local-zfs")
    ip           = string
    vm_id        = number
    cpu          = number
    memory       = number
    update       = optional(bool, false)
    igpu         = optional(bool, false)
  }))
}
