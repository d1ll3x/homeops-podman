terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~>0.111.0"
    }
  }
  backend "s3" {
    bucket = ""
    key    = ""
    region = ""
    profile= ""
  }
}

provider "proxmox" {
  endpoint = "https://${pveHost}:8006/api2/json"
  insecure = true
}
