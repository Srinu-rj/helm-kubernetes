# ============================================================
# CONTAINER REGISTRY — Private
# ============================================================
resource "azurerm_container_registry" "acr" {
  name                          = "acrprivateaks0208"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false

  # ✅ Geo-replication
  georeplications {
    location                = "West US"
    zone_redundancy_enabled = true
    tags                    = { environment = "prod" }
  }

  tags = {
    environment = "prod"
    managed_by  = "terraform"
  }
}
