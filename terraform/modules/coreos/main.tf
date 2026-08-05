resource "proxmox_storage_directory" "coreos" {
  id    = "coreos"
  path  = "/var/coreos"
  nodes = [var.node_name]

  content        = ["iso", "snippets"]
  create_subdirs = true
}

resource "proxmox_download_file" "fedora_coreos_qcow2_img" {
  content_type            = "iso"
  datastore_id            = proxmox_storage_directory.coreos.id
  node_name               = var.node_name
  url                     = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/44.20260707.3.1/x86_64/fedora-coreos-44.20260707.3.1-proxmoxve.x86_64.qcow2.xz"
  checksum                = "af91c10531a5205536b2f38f26629842b8c30c003be36a988545ad4cbd8f4f35"
  checksum_algorithm      = "sha256"
  overwrite               = false
  file_name               = "fedora-coreos-44.20260707.3.1-proxmoxve.x86_64.qcow2.xz.img"
  decompression_algorithm = "zst"
}

resource "proxmox_virtual_environment_file" "coreos_ignition" {
  content_type = "snippets"
  datastore_id = proxmox_storage_directory.coreos.id
  node_name    = var.node_name

  source_raw {
    data      = file("${path.module}/../../../coreos/ignition/init.ign")
    file_name = "init.ign"
  }
}

# Dummy VM for creating a persistent data disk
resource "proxmox_virtual_environment_vm" "coreos_data" {
  name       = "${var.vm_name}-data"
  node_name  = var.node_name
  started    = false
  on_boot    = false
  protection = true # Protect from accidentally deletion

  scsi_hardware = "virtio-scsi-single"

  disk {
    datastore_id = var.vm_datastore
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    ssd          = true
    size         = var.vm_disksize
  }
}

resource "proxmox_virtual_environment_vm" "coreos_vm" {
  name      = var.vm_name
  node_name = var.node_name
  tags      = var.vm_tags

  agent {
    enabled = true
  }

  stop_on_destroy = true

  machine = "q35"

  cpu {
    cores = var.vm_cpu
    type  = "host"
  }

  memory {
    dedicated = var.vm_ram
  }

  scsi_hardware = "virtio-scsi-single"

  # Boot disk
  disk {
    datastore_id = var.vm_datastore
    file_id      = proxmox_download_file.fedora_coreos_qcow2_img.id
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    ssd          = true
    size         = 20
  }

  # Attached disk for data persistence
  disk {
    path_in_datastore = proxmox_virtual_environment_vm.coreos_data.disk[0].path_in_datastore
    file_format       = proxmox_virtual_environment_vm.coreos_data.disk[0].file_format
    datastore_id      = proxmox_virtual_environment_vm.coreos_data.disk[0].datastore_id
    interface         = "scsi1"
    iothread          = proxmox_virtual_environment_vm.coreos_data.disk[0].iothread
    discard           = proxmox_virtual_environment_vm.coreos_data.disk[0].discard
    ssd               = proxmox_virtual_environment_vm.coreos_data.disk[0].ssd
    size              = proxmox_virtual_environment_vm.coreos_data.disk[0].size
  }

  initialization {
    datastore_id        = var.vm_datastore
    vendor_data_file_id = proxmox_virtual_environment_file.coreos_ignition.id
    upgrade             = false
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  # Set the mac_address to allow dhcp reservation
  network_device {
    bridge   = "vmbr0"
    mac_address = var.vm_mac
    firewall = true
  }

  operating_system {
    type = "l26"
  }

  vga {
    type = "serial0"
  }

  serial_device {}

  lifecycle {
    replace_triggered_by = [proxmox_virtual_environment_file.coreos_ignition]
  }
}

output "vm_ip" {
  value       = proxmox_virtual_environment_vm.coreos_vm.ipv4_addresses[1][0]
  description = "VM IPv4"
}
