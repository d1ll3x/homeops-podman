resource "proxmox_storage_directory" "coreos" {
  id = "coreos"
  path = "/var/coreos"
  nodes = [var.node_name]

  content = ["images","snippets"]
  create_subdirs = true
}

resource "proxmox_download_file" "release_20260707_fcos_44_qcow2_img" {
  content_type = "iso"
  datastore_id = proxmox_storage_directory.coreos.id
  node_name = var.node_name
  url = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/44.20260707.3.1/x86_64/fedora-coreos-44.20260707.3.1-proxmoxve.x86_64.qcow2.xz"
  checksum = "af91c10531a5205536b2f38f26629842b8c30c003be36a988545ad4cbd8f4f35"
  checksum_algorithm = "sha256"
  file_name = "fedora-coreos-44.20260707.3.1-proxmoxve.x86_64.qcow2.xz.img"
  decompression_algorithm = "zst"
}

resource "proxmox_virtual_environment_file" "fcos_ignition" {
  content_type = "snippets"
  datastore_id = proxmox_storage_directory.coreos.id
  node_name = var.node_name

  source_file {
    path = "https://raw.githubusercontent.com/d1ll3x/homeops-podman/refs/heads/main/fcos/ignition/init.ign"
    file_name = "config.ign"
  }
}

resource "proxmox_virtual_environment_vm" "fcos_vm" {
  name = var.vm_name
  node_name = var.node_name
  tags = var.vm_tags

  agent {
    enabled = true
  }

  stop_on_destroy = true

  machine = "q35"

  cpu {
    cores = var.vm_cpu
    type = "host"
  }

  memory {
    dedicated = var.vm_ram
  }

  disk {
    datastore_id = var.vm_datastore
    file_id = proxmox_download_file.release_20260707_fcos_44_qcow2_img.id
    interface = "scsi0"
    iothread = true
    discard = "on"
    ssd = true
    size = 20
  }

  initialization {
    datastore_id = var.vm_datastore
    user_data_file_id = proxmox_virtual_environment_file.fcos_ignition.id
    upgrade = false
    ip_config {
      ipv4 {
        address = "var.vm_ip"
        gateway = "var.vm_gw"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
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
    ignore_changes = [              # Ignore initialization section after first depoloyment for idempotency
      initialization
    ]
  }
}

output "vm_ip" {
  value = proxmox_virtual_environment_vm.vm.ipv4_addresses[0][0]
  description = "VM IPv4"
}
