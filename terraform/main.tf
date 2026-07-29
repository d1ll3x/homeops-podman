module "pve_vm" {
  source           = "../modules/pve_vm"
  vm_name          = "nautilus"
  vm_cpu           = 4
  vm_ram           = 8096
}

output "vm_ip" {
  value = module.pve_vm.vm_ip
}
