# resource "helm_release" "haproxy_ingress" {
#   name       = local.ha_proxy_name
#   repository = "https://haproxytech.github.io/helm-charts"
#   chart      = "kubernetes-ingress"
#   namespace  = "ingress-controller"
#   create_namespace = true
#
#   values = [
#     yamlencode({
#       controller = {
#         service = {
#           type = "LoadBalancer"
#         }
#       }
#     })
#   ]
# }
