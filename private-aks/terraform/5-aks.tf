resource "azurerm_user_assigned_identity" "assigned_identity" {
  name                = "base"
  resource_group_name = azurerm_resource_group.aks_rg_demo.name
  location            = azurerm_resource_group.aks_rg_demo.location
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = azurerm_resource_group.aks_rg_demo.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.assigned_identity.principal_id
}

resource "azurerm_kubernetes_cluster" "aks_cluster_backend" {
  name                = "${local.env}-${local.eks_name}"
  location            = azurerm_resource_group.aks_rg_demo.location
  resource_group_name = azurerm_resource_group.aks_rg_demo.name
  dns_prefix          = "devaks1"


  kubernetes_version = local.eks_version
  # automatic_channel_upgrade = "stable"
  private_cluster_enabled = false
  node_resource_group     = "${local.resource_group_name}-${local.env}-${local.eks_name}"

  # For production change to "Standard"
  sku_tier                  = "Free"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  azure_policy_enabled      = true


  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2as_v5"
  }

  # default_node_pool {
  #   name                 = "default"
  #   vm_size              = "Standard_D2as_v5"
  #   orchestrator_version = local.eks_version
  #   type                 = "VirtualMachineScaleSets"
  #   enable_auto_scaling  = true
  #   node_count           = 1
  #   min_count            = 1
  #   max_count            = 2
  #   os_disk_size_gb    = 100
  #   os_disk_type       = "Managed"
  #   os_sku             = "Ubuntu"
  #   # role_based_access_control_enabled = true
  #
  #   node_labels = {
  #     role = "general"
  #   }
  # }

  timeouts {
    create = "60m"
    update = "60m"
  }

  network_profile {
    network_plugin    = "azure"
    dns_service_ip    = "10.0.64.10"
    service_cidr      = "10.0.64.0/19"
    network_policy    = "calico"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }

  # identity {
  #   type         = "UserAssigned"
  #   identity_ids = [azurerm_user_assigned_identity.assigned_identity.id]
  # }

  tags = {
    Environment = local.env
  }

  depends_on = [
    azurerm_role_assignment.role_assignment
  ]

}

