module "coreos" {
  source  = "./modules/coreos"
  vm_name = local.vm.vm_name
  vm_cpu  = local.vm.vm_cpu
  vm_ram  = local.vm.vm_ram
  vm_ip   = local.vm.vm_ip
  vm_gw   = local.vm.vm_gw
}

locals {
  vm = {
    vm_name = "nautilus"
    vm_cpu  = 4
    vm_ram  = 8096
    vm_ip   = "192.168.20.100/24"
    vm_gw   = "192.168.20.1"
  }
}
