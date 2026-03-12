# ============================================================
# USER NODE POOL
# ============================================================
resource "azurerm_kubernetes_cluster_node_pool" "user_pool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D4s_v3"
  os_disk_size_gb       = 128
  os_disk_type          = "Ephemeral"
  vnet_subnet_id        = azurerm_subnet.aks_user_subnet.id
  pod_subnet_id         = azurerm_subnet.aks_pod_subnet.id
  zones                 = ["1", "2", "3"]
  mode                  = "User"
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 20
  node_count            = 2
  max_pods              = 110
  os_type               = "Linux"

  node_labels = {
    "role" = "user"
    "env"  = "prod"
  }

  upgrade_settings {
    max_surge = "33%"
  }

  tags = {
    environment = "prod"
    managed_by  = "terraform"
  }

  lifecycle {
    ignore_changes = [node_count]
  }
}
