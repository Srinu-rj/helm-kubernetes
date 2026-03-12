
# ============================================================
# AKS CLUSTER — Private
# ============================================================
resource "azurerm_kubernetes_cluster" "aks" {
  name                             = "aks-private-prod"
  location                         = azurerm_resource_group.rg.location
  resource_group_name              = azurerm_resource_group.rg.name
  dns_prefix                       = "aks-private-prod"
  kubernetes_version               = "1.28.3"
  node_resource_group              = "rg-aks-nodes-prod"
  sku_tier                         = "Standard"
  private_cluster_enabled          = true # ✅ Private Cluster
  private_dns_zone_id              = azurerm_private_dns_zone.aks_dns.id
  local_account_disabled           = true
  oidc_issuer_enabled              = true
  workload_identity_enabled        = true
  http_application_routing_enabled = false
  azure_policy_enabled             = true
  image_cleaner_enabled            = true
  image_cleaner_interval_hours     = 48

  # ✅ System Node Pool
  default_node_pool {
    name                         = "systempool"
    node_count                   = 2
    vm_size                      = "Standard_D4s_v3"
    os_disk_size_gb              = 128
    os_disk_type                 = "Ephemeral"
    vnet_subnet_id               = azurerm_subnet.aks_system_subnet.id
    pod_subnet_id                = azurerm_subnet.aks_pod_subnet.id
    only_critical_addons_enabled = true
    type                         = "VirtualMachineScaleSets"
    zones                        = ["1", "2", "3"]
    enable_auto_scaling          = true
    min_count                    = 2
    max_count                    = 5
    max_pods                     = 110

    node_labels = {
      "role" = "system"
      "env"  = "prod"
    }

    upgrade_settings {
      max_surge = "33%"
    }
  }

  # ✅ Managed Identity
  identity {
    type = "SystemAssigned"
  }

  # ✅ API Server VNet Integration
  api_server_access_profile {
    authorized_ip_ranges = [
      "203.0.113.0/24",   # ✅ Office IP range
      "198.51.100.10/32", # ✅ Single IP — DevOps Engineer
      "192.0.2.0/28",     # ✅ VPN IP range
      "10.243.4.0/24",    # ✅ Jumpbox subnet
      "10.243.2.0/24",    # ✅ Bastion subnet
    ]
  }

  # ✅ Azure CNI Networking
  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "calico"
    dns_service_ip      = "192.168.0.10"
    service_cidr        = "192.168.0.0/16"
    outbound_type       = "userAssignedNATGateway"
    load_balancer_sku   = "standard"
  }

  # ✅ Azure AD RBAC
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    tenant_id          = data.azurerm_client_config.current.tenant_id
  }

  # ✅ Container Insights
  oms_agent {
    log_analytics_workspace_id      = azurerm_log_analytics_workspace.logs.id
    msi_auth_for_monitoring_enabled = true
  }

  # ✅ Key Vault CSI Driver
  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  # ✅ Storage Profile
  storage_profile {
    blob_driver_enabled         = true
    disk_driver_enabled         = true
    file_driver_enabled         = true
    snapshot_controller_enabled = true
  }

  # ✅ Auto Scaler
  auto_scaler_profile {
    balance_similar_node_groups      = true
    expander                         = "random"
    scale_down_delay_after_add       = "10m"
    scale_down_unneeded              = "10m"
    scale_down_utilization_threshold = "0.5"
    scan_interval                    = "10s"
    skip_nodes_with_system_pods      = true
  }

  # ✅ Maintenance Window
  maintenance_window {
    allowed {
      day   = "Sunday"
      hours = [2, 3, 4]
    }
  }

  # ✅ Defender
  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id
  }

  tags = {
    environment = "prod"
    managed_by  = "terraform"
  }

  # lifecycle {
  #   ignore_changes = [
  #     default_node_pool[0].,
  #     kubernetes_version,
  #   ]
  # }

  depends_on = [
    azurerm_subnet_nat_gateway_association.system_nat,
    azurerm_log_analytics_solution.container_insights,
    azurerm_private_dns_zone_virtual_network_link.aks_dns_link
  ]
}
