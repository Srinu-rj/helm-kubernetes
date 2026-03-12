resource "azurerm_kubernetes_cluster_node_pool" "cluster_node_pool" {
  name                  = "internal"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster_backend.id
  vm_size               = "Standard_D2s_v3"
  eviction_policy       = "Delete"
  os_type               = "Linux"
  mode                  = "User"
  priority              = "Spot"
  enable_auto_scaling   = true
  spot_max_price        = -1
  node_count            = 1
  min_count             = 1
  max_count             = 10
  max_pods              = 50
  os_disk_type          = "Managed"
  vnet_subnet_id        = azurerm_subnet.subnet1.id

  node_labels = {
    role                                    = "spot"
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }

  upgrade_settings {
    max_surge = "33%"
  }

  node_taints = [
    "spot:NoSchedule",
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]
}
