data "azurerm_client_config" "current" {}

#TODO  kubelogin convert-kubeconfig -l azurecli ::==> https://blog.aks.azure.com/2026/01/09/deploy-aks-automatic-terraform-helm
# provider "helm" {
#   kubernetes = {
#     host                   = azurerm_kubernetes_cluster.aks_cluster_backend.kube_config.0.host
#     cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster_backend.kube_config.0.cluster_ca_certificate)
#
#     exec = {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       command     = "kubelogin"
#       args = [
#         "get-token",
#         "--login",
#         "azurecli",
#         "--server-id",
#         "6dae42f8-4368-4678-94ff-3960e28e3630"
#       ]
#     }
#   }
# }

# provider "helm" {
#   kubernetes = {
#     host     = "https://cluster_endpoint:port"
#
#     client_certificate     = file("~/.kube/client-cert.pem")
#     client_key             = file("~/.kube/client-key.pem")
#     cluster_ca_certificate = file("~/.kube/cluster-ca-cert.pem")
#   }
# }
