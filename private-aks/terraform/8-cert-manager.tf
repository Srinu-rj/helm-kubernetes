# data "azurerm_kubernetes_cluster" "aks" {
#   name                = azurerm_kubernetes_cluster.aks_cluster_backend.name
#   resource_group_name = azurerm_kubernetes_cluster.aks_cluster_backend.resource_group_name
# }
#
# provider "kubernetes" {
#   host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
#   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
#   client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
# }
#
#
#
#
# resource "helm_release" "cert_manager" {
#   name       = "cert-manager"
#   repository = "https://charts.jetstack.io"
#   chart      = "cert-manager"
#   version    = "v1.12.4"
#   namespace  = "cert-manager"
#   create_namespace = true
#
# }