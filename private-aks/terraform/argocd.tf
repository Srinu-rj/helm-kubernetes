resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true
  version    = "6.7.11"  # Use a stable version
  # values = [file("values.yaml")]
  values = [<<EOF
server:
  service:
    type: LoadBalancer
EOF
  ]


}

