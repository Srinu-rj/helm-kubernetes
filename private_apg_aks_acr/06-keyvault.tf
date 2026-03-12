# ============================================================
# KEY VAULT
# ============================================================
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv" {
  name                          = "kv-private-aks-0208"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  purge_protection_enabled      = true
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions      = ["Get", "List", "Set", "Delete"]
    certificate_permissions = ["Get", "List", "Create", "Delete", "Import"]
    key_permissions         = ["Get", "List", "Create", "Delete"]
  }

  tags = {
    environment = "prod"
    managed_by  = "terraform"
  }
}
