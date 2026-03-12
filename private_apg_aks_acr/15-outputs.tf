
output "aks_cluster_name" { value = azurerm_kubernetes_cluster.aks.name }
output "aks_cluster_id" { value = azurerm_kubernetes_cluster.aks.id }
output "aks_oidc_issuer_url" { value = azurerm_kubernetes_cluster.aks.oidc_issuer_url }
output "acr_login_server" { value = azurerm_container_registry.acr.login_server }
output "keyvault_uri" { value = azurerm_key_vault.kv.vault_uri }
output "appgw_public_ip" { value = azurerm_public_ip.appgw_pip.ip_address }
output "appgw_fqdn" { value = azurerm_public_ip.appgw_pip.fqdn }
output "nat_gateway_public_ip" { value = azurerm_public_ip.nat_pip.ip_address }
output "bastion_public_ip" { value = azurerm_public_ip.bastion_pip.ip_address }
output "vnet_id" { value = azurerm_virtual_network.vnet.id }

output "get_credentials" {
  value = "az aks get-credentials --resource-group rg-private-aks-prod --name aks-private-prod"
}

output "subnet_ids" {
  value = {
    aks_system = azurerm_subnet.aks_system_subnet.id
    aks_user   = azurerm_subnet.aks_user_subnet.id
    aks_pod    = azurerm_subnet.aks_pod_subnet.id
    aks_api    = azurerm_subnet.aks_api_subnet.id
    appgw      = azurerm_subnet.appgw_subnet.id
    private_ep = azurerm_subnet.private_endpoint_subnet.id
    bastion    = azurerm_subnet.bastion_subnet.id
    jumpbox    = azurerm_subnet.jumpbox_subnet.id
  }
}