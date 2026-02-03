helm template dev-deployment argocd/ -f argocd/dev-values.yaml > argocd-dev-deployment.yaml
helm template qa-deployment argocd/ -f argocd/qa-values.yaml > argocd-qa-deployment.yaml
helm template prod-deployment argocd/ -f argocd/prod-values.yaml > argocd-prod-deployment.yaml


helm install argocd-dev-realese argocd/ --values argocd/dev-values.yaml
helm install argocd-qa-realese argocd/ --values argocd/qa-values.yaml
helm install argocd-prod-realese argocd/ --values argocd/prod-values.yaml 

helm upgrade argocd-dev-realese argocd/ --values argocd/dev-values.yaml
helm upgrade argocd-qa-realese argocd/ --values argocd/qa-values.yaml
helm upgrade argocd-prod-realese argocd/ --values argocd/prod-values.yaml

helm uninstall argocd-qa-realese
helm uninstall argocd-dev-realese
helm uninstall argocd-prod-realese

helm template prod-deployment argocd/ -f argocd/prod-values.yaml | grep "# Source"

