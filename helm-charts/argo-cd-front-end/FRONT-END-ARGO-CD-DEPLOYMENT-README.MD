helm template front-end-dev-deployment argo-cd-front-end/ -f argo-cd-front-end/dev-values.yaml > argocd-front-end-dev-deployment.yaml
helm template front-end-qa-deployment argo-cd-front-end/ -f argo-cd-front-end/qa-values.yaml > argocd-front-end-qa-deployment.yaml
helm template front-end-prod-deployment argo-cd-front-end/ -f argo-cd-front-end/prod-values.yaml > argocd-front-end-prod-deployment.yaml


helm install argocd-front-end-qa-realese argo-cd-front-end/ --values argo-cd-front-end/dev-values.yaml
helm install argocd-front-end-dev-realese argo-cd-front-end/ --values argo-cd-front-end/qa-values.yaml
helm install argocd-front-end-prod-realese argo-cd-front-end/ --values argo-cd-front-end/prod-values.yaml 

helm upgrade argocd-front-end-qa-realese argo-cd-front-end/ --values argo-cd-front-end/dev-values.yaml
helm upgrade argocd-front-end-dev-realese argo-cd-front-end/ --values argo-cd-front-end/qa-values.yaml
helm upgrade argocd-front-end-prod-realese argo-cd-front-end/ --values argo-cd-front-end/prod-values.yaml

helm uninstall argocd-front-end-qa-realese
helm uninstall argocd-front-end-dev-realese
helm uninstall argocd-front-end-prod-realese

helm template prod-deployment argocd/ -f argocd/prod-values.yaml | grep "# Source"

