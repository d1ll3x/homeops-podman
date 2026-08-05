module "coreos" {
  source  = "./modules/coreos"
  vm_name = "nautilus"
  vm_cpu  = 4
  vm_ram  = 8192
  vm_mac  = "BC:24:11:05:E2:C5"
}

output "vm_ip" {
  value = module.coreos.vm_ip
}
