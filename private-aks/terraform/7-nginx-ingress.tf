# provider "kubernetes" {
#   host                   = azurerm_kubernetes_cluster.aks_cluster_backend.kube_config[0].host
#   client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_cluster_backend.kube_config[0].client_certificate)
#   client_key             = base64decode(azurerm_kubernetes_cluster.aks_cluster_backend.kube_config[0].client_key)
#   cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster_backend.kube_config[0].cluster_ca_certificate)
# }
#
# provider "helm" {
#   kubernetes = {
#     host                   = azurerm_kubernetes_cluster.aks_cluster_backend.kube_config[0].host
#     client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_cluster_backend.kube_config[0].client_certificate)
#     client_key             = base64decode(azurerm_kubernetes_cluster.aks_cluster_backend.kube_config[0].client_key)
#     cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster_backend.kube_config[0].cluster_ca_certificate)
#   }
# }
#
# # ========================
# # TODO INGRESS
# # ========================
# # resource "helm_release" "nginx_ingress" {
# #   name       = "nginx-ingress"
# #   namespace  = "ingress-nginx"
# #   repository = "https://kubernetes.github.io/ingress-nginx"
# #   chart      = "ingress-nginx"
# #   version    = "4.0.6"
# #
# #   set {
# #     name  = "rbac.create"
# #     value = "true"
# #   }
# #
# #   set {
# #     name  = "controller.service.type"
# #     value = "LoadBalancer"
# #   }
# #
# #   set {
# #     name  = "controller.replicaCount"
# #     value = "2"
# #   }
# #
# #   set {
# #     name  = "controller.nodeSelector.kubernetes.io/os"
# #     value = "linux"
# #   }
# #
# #   set {
# #     name  = "controller.service.annotations.service.beta.kubernetes.io/azure-load-balancer-internal"
# #     value = "true"
# #   }
# #
# #   depends_on = [azurerm_kubernetes_cluster.aks_cluster_backend]
# # }
# #
# resource "azurerm_public_ip" "ingress" {
#   name                = "aks-ingress-public-ip"
#   resource_group_name = azurerm_resource_group.aks_rg_demo.name
#   location            = "South India"
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }
#
# # Pass the IP to Helm
# # set {
# #   name  = "controller.service.loadBalancerIP"
# #   value = azurerm_public_ip.ingress.ip_address
# # }
#
# # ========================
# # TODO HA PROXY
# # ========================
#
# resource "helm_release" "haproxy_ingress" {
#   name       = "haproxy-ingress"
#   repository = "https://haproxytech.github.io/helm-charts"
#   chart      = "haproxy-ingress"
#   namespace  = "ingress"
#   create_namespace = true
#
# }
#
# # ========================
# # TODO traefik
# # ========================
# # resource "kubernetes_namespace_v1" "traefik" {
# #   metadata {
# #     name = "traefik"
# #   }
# # }
# #
# #
# # resource "helm_release" "traefik" {
# #   name       = "traefik"
# #   repository = "https://helm.traefik.io/traefik"
# #   chart      = "traefik"
# #   version    = "26.0.0"
# #   namespace  = kubernetes_namespace.traefik.metadata.0.name
# #
# #   set {
# #     name  = "ports.web.redirectTo.port"
# #     value = "websecure"
# #   }
# #
# #   set {
# #     name  = "additionalArguments"
# #     value = "{--entryPoints.websecure.forwardedHeaders.trustedIPs=10.0.0.0/8}"
# #   }
# # }