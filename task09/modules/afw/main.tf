data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
}

data "azurerm_subnet" "aks_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
}

resource "azurerm_subnet" "afw_subnet" {
  name                 = var.afw_subnet
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.cidr_block]
}

resource "azurerm_public_ip" "afw_pip" {
  name                = local.pub_ip
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = var.afw_allocation_method
  sku                 = var.afw_pip_sku

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_firewall" "afw" {
  name                = local.afw_name
  location            = var.location
  resource_group_name = var.rg_name
  sku_name            = var.afw_sku_name
  sku_tier            = var.afw_pip_sku

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.afw_subnet.id
    public_ip_address_id = azurerm_public_ip.afw_pip.id
  }
}

resource "azurerm_route_table" "rt" {
  name                          = local.rt_name
  location                      = var.location
  resource_group_name           = var.rg_name
  bgp_route_propagation_enabled = false

  route {
    name                   = "route-to-fw"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.afw.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "rt_asso" {
  subnet_id      = data.azurerm_subnet.aks_subnet.id
  route_table_id = azurerm_route_table.rt.id
}

resource "azurerm_firewall_application_rule_collection" "app_rule" {
  name                = local.afw_app_rule
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.rg_name
  priority            = 100
  action              = var.fw_collection_rule_type

  dynamic "rule" {
    for_each = local.app_rules
    content {
      name             = rule.value.name
      source_addresses = rule.value.source_addresses
      target_fqdns     = rule.value.target_fqdns

      protocol {
        port = "80"
        type = "Http"
      }

      protocol {
        port = "443"
        type = "Https"
      }
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "net_rule" {
  name                = local.afw_net_rule
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.rg_name
  priority            = 200
  action              = var.fw_collection_rule_type

  dynamic "rule" {
    for_each = local.network_rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      protocols             = rule.value.protocols
    }
  }
}

resource "azurerm_firewall_nat_rule_collection" "nat_rule" {
  name                = local.afw_nat_rule
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.rg_name
  priority            = 300
  action              = var.afw_nat_action_type

  dynamic "rule" {
    for_each = local.nat_rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
      protocols             = rule.value.protocols
    }
  }

  provisioner "local-exec" {
    command = <<EOT
      RG_NAME="cmtr-4iyfgpi2-mod9-rg"
      PUBLIC_IP_NAME="cmtr-4iyfgpi2-mod9-pip"
      AKS_CLUSTER_NAME="cmtr-4iyfgpi2-mod9-aks"

      echo "Waiting Terraform to create firewall Public IP"
      while true; do
          public_ip_address=$(az network public-ip show -g "$RG_NAME" -n "$PUBLIC_IP_NAME" --query ipAddress -o tsv 2>/dev/null)
          if [ ! -z "$public_ip_address" ]; then
              echo "Firewall pub ip found: $public_ip_address"
              break
          fi
          sleep 5
      done

      echo "Finding AKS internal NSG and current LoadBalancer IP..."
      aks_rg=$(az aks show -n $AKS_CLUSTER_NAME -g $RG_NAME --query nodeResourceGroup -o tsv)
      aks_nsg=$(az resource list -g $aks_rg --resource-type=Microsoft.Network/networkSecurityGroups --query "[0].name" -o tsv)

      LB_IP_ADDRESS=$(kubectl get svc nginx-loadbalancer -n default -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

      echo "Current AKS LoadBalancer IP is: $LB_IP_ADDRESS"
      echo "NSG found: $aks_nsg. Adding Security Rules.."

      az network nsg rule create \
        --resource-group "$aks_rg" \
        --nsg-name "$aks_nsg" \
        --name AllowAccessFromFirewallPublicIPToLoadBalancerIP \
        --priority 400 \
        --access Allow \
        --protocol "*" \
        --direction Inbound \
        --source-address-prefix "$public_ip_address" \
        --source-port-range "*" \
        --destination-address-prefix "$LB_IP_ADDRESS" \
        --destination-port-range 80

      echo "Rule Added Successfully! Traffic Is Opened."
    EOT
  }
}