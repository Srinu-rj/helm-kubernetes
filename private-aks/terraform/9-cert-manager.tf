
# resource "helm_release" "cert_manager" {
#   name       = "aks-cert-manager"
#   repository = "https://charts.jetstack.io"
#   chart      = "cert-manager"
#   namespace  = "cert-manager"
#   create_namespace = true
#
#   values = [
#     yamlencode({
#       installCRDs = true
#     })
#   ]
#
#   depends_on = [
#     helm_release.haproxy_ingress
#   ]
# }
#
