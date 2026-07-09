unique_id = "cmtr-4iyfgpi2-mod9"

location = "France Central"

rg_name = "cmtr-4iyfgpi2-mod9-rg"

vnet_name = "cmtr-4iyfgpi2-mod9-vnet"

vnet_space = "10.0.0.0/16"

subnet_name = "aks-snet"

aks_subnet_space = "10.0.0.0/24"

aks_cluster_name = "cmtr-4iyfgpi2-mod9-aks"

aks_loadbalancer_ip = "20.216.199.139"

public_ip_name = "cmtr-4iyfgpi2-mod9-pip"

afw_subnet = "AzureFirewallSubnet"

cidr_block = "10.0.1.0/24"

afw_allocation_method = "Static"

afw_pip_sku = "Standard"

afw_sku_name = "AZFW_VNet"

fw_collection_rule_type = "Allow"

afw_nat_action_type = "Dnat"

nsg_name = "aks-agentpool-32024204-nsg"

aks_rg_name = "MC_cmtr-4iyfgpi2-mod9-rg_cmtr-4iyfgpi2-mod9-aks_francecentral"

nsg_rule_name = "AllowAccessFromFirewallPublicIPToLoadBalancerIP"

direction_type = "Inbound"

wildcard = "*"

destination_port_range = "80"