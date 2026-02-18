# data "azurerm_resource_group" "aks_rg" {
#   name = local.resource_group_name
# }
# data "azurerm_kubernetes_cluster" "kubernetes_cluster" {
#   name                = ""
#   resource_group_name = ""
# }
# data "azurerm_client_config" "current" {}
# provider "helm" {
#   kubernetes {
#     host                   = azurerm_kubernetes_cluster.aks_cluster_backend.kube_config.0.host
#     cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster_backend.kube_config.0.cluster_ca_certificate)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       command     = "kubelogin"
#       args = [
#         "get-token",
#         "--login", "azurecli",
#         "--server-id", "6dae42f8-4368-4678-94ff-3960e28e3630", # AKS AAD Server App ID
#         "--tenant-id", data.azurerm_client_config.current.tenant_id,
#         "--client-id", yamldecode(azurerm_kubernetes_cluster.aks_cluster_backend.kube_config_raw).users.user.auth-provider.config.client-id
#       ]
#     }
#   }
# }
