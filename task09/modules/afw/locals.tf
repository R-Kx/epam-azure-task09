locals {
  pub_ip       = format("%s-afw-pip", var.unique_id)
  afw_name     = format("%s-afw", var.unique_id)
  rt_name      = format("%s-rt", var.unique_id)
  afw_app_rule = format("%s-afw-app-rule", var.unique_id)
  afw_net_rule = format("%s-afw-net-rule", var.unique_id)
  afw_nat_rule = format("%s-afw-nat-rule", var.unique_id)
  network_rules = [
    {
      name                  = "allow-dns"
      source_addresses      = [var.aks_subnet_space]
      destination_ports     = ["53"]
      destination_addresses = ["*"]
      protocols             = ["UDP", "TCP"]
    }
  ]

  app_rules = [
    {
      name             = "allow-http-https"
      source_addresses = [var.aks_subnet_space]
      target_fqdns     = ["*.microsoft.com", "*.azure.com", "*.azmk8s.io", "*.production.fluentbit.io"]
    }
  ]

  nat_rules = [
    {
      name               = "nat-to-aks-nginx"
      source_addresses   = ["*"]
      destination_ports  = ["80"]
      translated_address = var.aks_loadbalancer_ip
      translated_port    = "80"
      protocols          = ["TCP"]
    }
  ]
}