output "hub_vnet_name" { 
    description     = "Hub VNET Name"
    value           = azurerm_virtual_network.hub.name
}

output "hub_vnet_id" {
    description     = "Hub VNET Id"
    value           = azurerm_virtual_network.hub.id 
}

output "hub_address_space" { 
    description     = "Hub Address Space"
    value           = azurerm_virtual_network.hub.address_space
}

output "spoke_vnet_name" {
    description     = "Spoke VNET Name"
    value           = azurerm_virtual_network.spoke.name
}

output "spoke_vnet_id" {
    description     = "Spoke VNET Id"
    value           = azurerm_virtual_network.spoke.id
}

output "spoke_address_space" { 
    description     = "Spoke Address Space"
    value           = azurerm_virtual_network.spoke.address_space
}
