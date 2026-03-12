
resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = "dev-test"
  resource_group_name = azurerm_resource_group.aks_rg_demo.name
  location            = azurerm_resource_group.aks_rg_demo.location
}

resource "azurerm_federated_identity_credential" "federated_identity_credential" {
  name                = "dev-test"
  resource_group_name = local.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks_cluster_backend.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.user_assigned_identity.id
  subject             = "system:serviceaccount:dev:my-account"

  depends_on = [azurerm_kubernetes_cluster.aks_cluster_backend]
}
