output "az_firewall_public_ip" {
  value       = azurerm_public_ip.afw_pip.ip_address
  description = "Pub ip of afw"
}

output "az_firewall_private_ip" {
  value       = azurerm_firewall.afw.ip_configuration[0].private_ip_address
  description = "private ip address of afw"
}