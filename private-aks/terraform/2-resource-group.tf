resource "azurerm_resource_group" "aks_rg_demo" {
  name     = local.resource_group_name
  location = local.region
}
