data "azurerm_client_config" "current" {}
# Identity
resource "azurerm_user_assigned_identity" "aks" {
  name                = "aks-prod-identity"
  resource_group_name = azurerm_resource_group.aks_rg_demo.name
  location            = azurerm_resource_group.aks_rg_demo.location
}
# PRIVATE DNS ZONE — AKS Internal Load Balancer
resource "azurerm_private_dns_zone" "aks_dns" {
  name                = "privatelink.eastus2.azmk8s.io"
  resource_group_name = azurerm_resource_group.aks_rg_demo.name
  tags                = azurerm_resource_group.aks_rg_demo.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks" {
  name                  = "pdnslink-aks-vnet-prod"
  resource_group_name   = azurerm_resource_group.aks_rg_demo.name
  private_dns_zone_name = azurerm_private_dns_zone.aks_dns.name
  virtual_network_id    = azurerm_virtual_network.aks_vnet_demo.id
  registration_enabled  = false
  tags                  = azurerm_resource_group.aks_rg_demo.tags
}

# Subnet permission
resource "azurerm_role_assignment" "subnet" {
  scope                = azurerm_subnet.subnet1.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}
resource "azurerm_role_assignment" "aks_admin" {
  scope                = azurerm_kubernetes_cluster.aks_cluster_backend.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}
# Node RG permission
resource "azurerm_role_assignment" "node_rg" {
  scope                = azurerm_resource_group.aks_rg_demo.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_kubernetes_cluster" "aks_cluster_backend" {
  name                = local.eks_name #"${local.env}-${local.eks_name}"
  location            = azurerm_resource_group.aks_rg_demo.location
  resource_group_name = azurerm_resource_group.aks_rg_demo.name
  dns_prefix          = "devaks1"
  kubernetes_version  = local.eks_version
  # automatic_channel_upgrade = "stable"
  private_cluster_enabled = false
  node_resource_group     = local.resource_group_name #"${local.resource_group_name}-${local.env}-${local.eks_name}"

  # For production change to "Standard"
  sku_tier                  = "Free"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  azure_policy_enabled      = true
  # Disable local admin accounts — Azure AD only
  local_account_disabled = true
  automatic_channel_upgrade = "patch"

  default_node_pool {
    name                         = "default"
    vm_size                      = "Standard_D2as_v5"
    orchestrator_version         = local.eks_version
    type                         = "VirtualMachineScaleSets"
    vnet_subnet_id               = azurerm_subnet.subnet1.id
    enable_node_public_ip        = false
    node_count                   = 2
    enable_auto_scaling          = true
    min_count                    = 1
    max_count                    = 3
    os_disk_size_gb              = 100
    os_disk_type                 = "Managed"
    os_sku                       = "Ubuntu"
    only_critical_addons_enabled = true #TODO Keep system pool tainted for system pods
    node_labels = {
      role = "general"
    }
    upgrade_settings {
      max_surge = "33%"
    }
  }


  # ✅ Storage Profile
  storage_profile {
    blob_driver_enabled         = true
    disk_driver_enabled         = true
    file_driver_enabled         = true
    snapshot_controller_enabled = true
  }

  network_profile {
    network_plugin    = "azure"
    dns_service_ip    = "10.0.64.10"
    service_cidr      = "10.0.64.0/19"
    network_policy    = "calico"
    load_balancer_sku = "standard"
    # network_mode      = "overlay"
  }

  # TODO Note: Managed Identity is not available for all services in Azure, Its available mainly for PAAS services.
  # TODO ==>  Use system-assigned when you need a unique identity per resource with automatic cleanup.
  # identity {
  #   type = "SystemAssigned"
  # }

  # TODO ==> Use user-assigned when you need shared identities, pre-authorization, or reduced management overhead across multiple resources.
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }
  #TODO->  Monitoring (Container Insights)
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
  }
  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }
  # maintenance_window_node_os = {
  #   day_of_week = "Tuesday"
  #   frequency   = "Weekly"
  #   interval    = 1
  #   duration    = 4
  #   start_time  = "09:00"
  #   utc_offset  = "+00:00"
  #   not_allowed = [
  #     {
  #       start = "2026-03-25T00:00:00Z"
  #       end   = "2026-05-01T23:59:59Z"
  #     }
  #   ]
  # }
  maintenance_window {
    allowed {
      day   = "Sunday"
      hours = [0, 1, 2, 3]
    }
  }
  # TODO  SecurityPatch ==> Applies only security patches. This is the default and recommended for most production workloads. It follows safe deployment practices and honors maintenance windows.
  # TODO  NodeImage ==> Performs full node image reimages. This channel is used when you want to ensure the latest OS image is applied, but it can cause more disruption\
  # TODO  None  ==> Disables automatic OS upgrades (not recommended for production).
  node_os_channel_upgrade = "NodeImage" #SecurityPatch

  # TODO Image cleaner
  image_cleaner_enabled        = true
  image_cleaner_interval_hours = 48

  tags = {
    Environment = local.env
  }

  depends_on = [
    azurerm_user_assigned_identity.aks
  ]

  # TODO ==> Entra ID + Kubernetes RBAC
  # role_based_access_control_enabled = true

  # azure_active_directory_role_based_access_control {
  #  #   azure_rbac_enabled = true
  #  # }
  # ✅ Azure AD RBAC
  # azure_active_directory_role_based_access_control {
  #   managed            = true
  #   azure_rbac_enabled = true
  #   tenant_id          = data.azurerm_client_config.current.tenant_id
  # }
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "loganalyticsk8s"
  location            = azurerm_resource_group.aks_rg_demo.location
  resource_group_name = azurerm_resource_group.aks_rg_demo.name
  sku                 = "PerGB2018"
  retention_in_days   = 90
}

resource "azurerm_monitor_diagnostic_setting" "aks" {
  name                       = "diag-aks-prod"
  target_resource_id         = azurerm_kubernetes_cluster.aks_cluster_backend.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

  enabled_log { category = "kube-apiserver" }
  enabled_log { category = "kube-controller-manager" }
  enabled_log { category = "kube-scheduler" }
  enabled_log { category = "kube-audit" }
  enabled_log { category = "kube-audit-admin" }
  enabled_log { category = "guard" }

}

