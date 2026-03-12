# deploy.ps1
$ErrorActionPreference = "Stop"

Write-Host "=============================="
Write-Host " Terraform Deploy"
Write-Host "=============================="

terraform init
terraform validate
terraform fmt

Write-Host "[1]  Resource Group..."
terraform apply -target="azurerm_resource_group.rg" -auto-approve

Write-Host "[2]  Networking..."
terraform apply -target="azurerm_virtual_network.vnet" -auto-approve

Write-Host "[3]  NSG..."
terraform apply `
  -target="azurerm_network_security_group.aks_system_nsg" `
  -target="azurerm_network_security_group.appgw_nsg" `
  -target="azurerm_network_security_group.jumpbox_nsg" `
  -auto-approve

Write-Host "[4]  NAT Gateway..."
terraform apply -target="azurerm_nat_gateway.nat_gw" -auto-approve

Write-Host "[5]  Private DNS Zones..."
terraform apply `
  -target="azurerm_private_dns_zone.aks_dns" `
  -target="azurerm_private_dns_zone.acr_dns" `
  -target="azurerm_private_dns_zone.kv_dns" `
  -target="azurerm_private_dns_zone.blob_dns" `
  -auto-approve

Write-Host "[6]  DNS VNet Links..."
terraform apply `
  -target="azurerm_private_dns_zone_virtual_network_link.aks_dns_link" `
  -target="azurerm_private_dns_zone_virtual_network_link.acr_dns_link" `
  -target="azurerm_private_dns_zone_virtual_network_link.kv_dns_link" `
  -target="azurerm_private_dns_zone_virtual_network_link.blob_dns_link" `
  -auto-approve

Write-Host "[7]  AKS Identity + Roles..."
terraform apply `
  -target="azurerm_user_assigned_identity.aks_identity" `
  -target="azurerm_role_assignment.aks_dns_contributor" `
  -target="azurerm_role_assignment.aks_vnet_contributor" `
  -auto-approve

Write-Host "[8]  Key Vault..."
terraform apply -target="azurerm_key_vault.kv" -auto-approve

Write-Host "[9]  ACR..."
terraform apply -target="azurerm_container_registry.acr" -auto-approve

Write-Host "[10] Log Analytics..."
terraform apply `
  -target="azurerm_log_analytics_workspace.logs" `
  -target="azurerm_log_analytics_solution.container_insights" `
  -auto-approve

Write-Host "[11] AKS Cluster..."
terraform apply -target="azurerm_kubernetes_cluster.aks" -auto-approve

Write-Host "[12] Node Pools..."
terraform apply -target="azurerm_kubernetes_cluster_node_pool.user_pool" -auto-approve

Write-Host "[13] App Gateway..."
terraform apply `
  -target="azurerm_web_application_firewall_policy.waf" `
  -target="azurerm_application_gateway.appgw" `
  -auto-approve

Write-Host "[14] Private Endpoints..."
terraform apply `
  -target="azurerm_private_endpoint.acr_pe" `
  -target="azurerm_private_endpoint.kv_pe" `
  -auto-approve

Write-Host "[15] Bastion..."
terraform apply -target="azurerm_bastion_host.bastion" -auto-approve

Write-Host "[16] Final Apply..."
terraform apply -auto-approve

Write-Host "=============================="
Write-Host " Deploy Complete!"
Write-Host "=============================="
terraform output