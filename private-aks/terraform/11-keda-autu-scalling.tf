
# resource "helm_release" "keda" {
#   name             = "keda"
#   repository       = "https://kedacore.github.io/charts"
#   chart            = "keda"
#   namespace        = "keda"
#   create_namespace = true
#
#   version = "2.14.2" # optional but recommended to pin version
#
#   values = [
#     yamlencode({
#       prometheus = {
#         metricServer = {
#           enabled = true
#         }
#       }
#     })
#   ]
#
#   depends_on = [
#     azurerm_kubernetes_cluster.aks_cluster_backend
#   ]
# }
#
