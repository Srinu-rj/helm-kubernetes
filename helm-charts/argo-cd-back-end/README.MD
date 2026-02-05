helm template back-end-dev-deployment argo-cd-back-end/ -f argo-cd-back-end/dev-values.yaml > argocd-back-end-dev-deployment.yaml
helm template back-end-qa-deployment argo-cd-back-end/ -f argo-cd-back-end/qa-values.yaml > argocd-back-end-qa-deployment.yaml
helm template back-end-prod-deployment argo-cd-back-end/ -f argo-cd-back-end/prod-values.yaml > argocd-back-end-prod-deployment.yaml


helm install argocd-back-end-qa-realese argocd/ --values argocd/dev-values.yaml
helm install argocd-back-end-dev-realese argocd/ --values argocd/qa-values.yaml
helm install argocd-back-end-prod-realese argocd/ --values argocd/prod-values.yaml 

helm upgrade argocd-back-end-qa-realese argocd/ --values argocd/dev-values.yaml
helm upgrade argocd-back-end-dev-realese argocd/ --values argocd/qa-values.yaml
helm upgrade argocd-back-end-prod-realese argocd/ --values argocd/prod-values.yaml

helm uninstall argocd-back-end-qa-realese
helm uninstall argocd-back-end-dev-realese
helm uninstall argocd-back-end-prod-realese

helm template prod-deployment argocd/ -f argocd/prod-values.yaml | grep "# Source"

