variable "node_name" {
  description = "Proxmox node to host the VM"
  type        = string
  default     = "pve-1"
}

variable "vm_name" {
  description = "Hostname of the VM"
  type        = string
}

variable "vm_tags" {
  description = "Tags to add to the VM"
  type        = list(any)
  default     = ["coreos"]
}

variable "vm_cpu" {
  description = "Amount of CPU cores to allocate"
  type        = number
  default     = 2
}

variable "vm_ram" {
  description = "Amount of RAM to allocate"
  type        = number
  default     = 2048
}

variable "vm_disksize" {
  description = "Size of the persistent data disk for the VM"
  type        = number
  default     = 150
}

variable "vm_ip" {
  description = "IPv4 address assigned to the VM"
  type        = string
}

variable "vm_gw" {
  description = "Gateway address assigned to the VM"
  type        = string
}

variable "vm_datastore" {
  description = "Datastore used for VM storage"
  type        = string
  default     = "compute"
}
