output "azure_firewall_public_ip" {
  value       = module.afw.az_firewall_public_ip
  description = "Pub ip of afw"
}

output "azure_firewall_private_ip" {
  value       = module.afw.az_firewall_private_ip
  description = "private ip address of afw"
}