locals {
  aks_principal_id = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  # aks_kubelet_id       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].
  aks_kv_identity_id = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id
}


# ✅ AKS pulls from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = local.aks_principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# ✅ AKS Key Vault Secrets access
resource "azurerm_role_assignment" "aks_kv_secrets" {
  principal_id         = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id
  role_definition_name = "Key Vault Secrets User"
  scope                = azurerm_key_vault.kv.id
}

# ✅ AppGW managed identity — Key Vault
resource "azurerm_role_assignment" "appgw_kv" {
  principal_id         = azurerm_user_assigned_identity.appgw_identity.principal_id
  role_definition_name = "Key Vault Certificate User"
  scope                = azurerm_key_vault.kv.id
}

# ✅ AKS network contributor
resource "azurerm_role_assignment" "aks_network" {
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  role_definition_name = "Network Contributor"
  scope                = azurerm_virtual_network.vnet.id
}

# ✅ AKS private DNS contributor
resource "azurerm_role_assignment" "aks_dns" {
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  role_definition_name = "Private DNS Zone Contributor"
  scope                = azurerm_private_dns_zone.aks_dns.id
}

# ✅ AKS Key Vault access
resource "azurerm_role_assignment" "aks_kv" {
  principal_id         = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id
  role_definition_name = "Key Vault Secrets User"
  scope                = azurerm_key_vault.kv.id
}


