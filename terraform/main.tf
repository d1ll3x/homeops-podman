module "coreos" {
  source  = "./modules/coreos"
  vm_name = local.vm.vm_name
  vm_cpu  = local.vm.vm_cpu
  vm_ram  = local.vm.vm_ram
}

locals {
  vm = {
    vm_name = "nautilus"
    vm_cpu  = 4
    vm_ram  = 8096
  }
}
