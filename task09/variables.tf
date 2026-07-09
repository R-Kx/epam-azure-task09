variable "unique_id" {
  type        = string
  description = "resource naming convention"
}

variable "location" {
  type        = string
  description = "region for resources"
}

variable "rg_name" {
  type        = string
  description = "name of existing rg"
}

variable "vnet_name" {
  type        = string
  description = "name of existing vnet"
}

variable "vnet_space" {
  type        = string
  description = "existing vnet address space"
}

variable "subnet_name" {
  type        = string
  description = "name of existing subnet"
}

variable "subnet_space" {
  type        = string
  description = "existing subnet addess space"
}

variable "aks_cluster_name" {
  type        = string
  description = "name of existing aks cluster"
}

variable "aks_loadbalancer_ip" {
  type        = string
  description = "name of existing aks lb pub ip"
}

variable "public_ip_name" {
  type        = string
  description = "name of fw pub ip"
}

variable "afw_subnet" {
  type        = string
  description = "name of afw subnet resource"
}

variable "cidr_block" {
  type        = string
  description = "value of cidr block for subnet resource"
}


variable "afw_allocation_method" {
  type        = string
  description = "allocation method for firewall"
}

variable "afw_pip_sku" {
  type        = string
  description = "sku of afw pub ip"
}

variable "afw_sku_name" {
  type        = string
  description = "afw sku name"
}

variable "fw_collection_rule_type" {
  type        = string
  description = "fw collection rule type"
}

variable "afw_nat_action_type" {
  type        = string
  description = "nat collection rule action type"
}