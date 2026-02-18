resource "azurerm_virtual_network" "aks_vnet_demo" {
  name                = "main"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.aks_rg_demo.name
  location            = azurerm_resource_group.aks_rg_demo.location

  tags = {
    env = local.env
  }
}
