# Azure provider version 
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
    version = "=2.32.0"
    features {} 
}

# Resource group 
resource "azurerm_resource_group" "private_aks_demo" {
    name                        = var.resource_group_name
    location                    = var.location
    tags                        = var.tags 
}

# Hub-Spoke VNET, Azure Bastion, Azure Firewall, BIND DNS 
module "hub_spoke" { 
    source                          = "./modules/single_region_hub_spoke"
    resource_group_name             = var.resource_group_name
    location                        = var.location

    hub_vnet_name                   = var.hub_vnet_name
    hub_vnet_addr_prefix            = var.hub_vnet_addr_prefix
    spoke_vnet_name                 = var.spoke_vnet_name
    spoke_vnet_addr_prefix          = var.spoke_vnet_addr_prefix

    azurefw_name                    = var.azurefw_name
    azurefw_addr_prefix             = var.azurefw_addr_prefix

    azurebastion_name               = var.azurebastion_name
    azurebastion_addr_prefix        = var.azurebastion_addr_prefix

    bind_dns_name                   = var.bind_dns_name
    bind_dns_addr_prefix            = var.bind_dns_addr_prefix
    bind_private_ip_addr            = var.bind_private_ip_addr
    bind_ssh_source_addr_prefixes   = var.bind_ssh_source_addr_prefixes
    bind_vm_size                    = var.bind_vm_size
    admin_username                  = var.admin_username
    pub_key_name                    = var.pub_key_name
}

# Azure Container Registry, Azure Private DNS and Hub Private Endpoint Subnet
module "private_acr" { 
    source                          = "./modules/azure_container_registry"
    resource_group_name             = var.resource_group_name
    location                        = var.location
    acr_vnet_name                   = module.hub_spoke.hub_vnet_name
    acr_vnet_id                     = module.hub_spoke.hub_vnet_id
    acr_addr_prefix                 = var.acr_addr_prefix
    acr_name                        = var.acr_name
    acr_georeplication_locations    = var.acr_georeplication_locations
}

# Private AKS Cluster 
module "private_aks" {
    source                          = "./modules/azure_kubernetes_service"
    resource_group_name             = var.resource_group_name
    location                        = var.location
    aks_name                        = var.aks_name
    aks_vnet_name                   = module.hub_spoke.spoke_vnet_name
    aks_subnet_addr_prefix          = var.aks_subnet_addr_prefix
    custom_dns_vnet_id              = module.hub_spoke.hub_vnet_id
    aks_dns_prefix                  = var.aks_dns_prefix
    aks_k8s_version                 = var.aks_k8s_version
    aks_admin_username              = var.aks_admin_username
    aks_pub_key_name                = var.aks_pub_key_name
    aks_default_pool_name           = var.aks_default_pool_name
    aks_default_pool_node_count     = var.aks_default_pool_node_count
    aks_default_pool_vm_size        = var.aks_default_pool_vm_size
    aks_default_pool_os_disk_size   = var.aks_default_pool_os_disk_size
    aks_service_cidr                = var.aks_service_cidr
    aks_dns_service_ip              = var.aks_dns_service_ip
    aks_docker_bridge_cidr          = var.aks_docker_bridge_cidr
}
