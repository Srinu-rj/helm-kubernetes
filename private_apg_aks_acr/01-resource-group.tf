resource "azurerm_resource_group" "rg" {
  name     = "rg-private-aks-prod"
  location = "East US"

  tags = {
    environment = "prod"
    managed_by  = "terraform"
    project     = "private-aks"
  }
}