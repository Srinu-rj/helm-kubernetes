# ============================================================
# PRIVATE DNS ZONES
# ============================================================

resource "azurerm_private_dns_zone" "acr_dns" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = { environment = "prod", managed_by = "terraform" }
}

resource "azurerm_private_dns_zone" "kv_dns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = { environment = "prod", managed_by = "terraform" }
}

resource "azurerm_private_dns_zone" "blob_dns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = { environment = "prod", managed_by = "terraform" }
}

resource "azurerm_private_dns_zone" "aks_dns" {
  name                = "privatelink.eastus.azmk8s.io"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = { environment = "prod", managed_by = "terraform" }
}

# ============================================================
# VNet Links
# ============================================================
resource "azurerm_private_dns_zone_virtual_network_link" "acr_dns_link" {
  name                  = "link-acr-dns"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.acr_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = { environment = "prod", managed_by = "terraform" }
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv_dns_link" {
  name                  = "link-kv-dns"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.kv_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = { environment = "prod", managed_by = "terraform" }
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_dns_link" {
  name                  = "link-blob-dns"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.blob_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = { environment = "prod", managed_by = "terraform" }
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_dns_link" {
  name                  = "link-aks-dns"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.aks_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = { environment = "prod", managed_by = "terraform" }
}