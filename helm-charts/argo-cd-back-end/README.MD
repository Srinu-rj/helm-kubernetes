helm template back-end-dev-deployment argo-cd-back-end/ -f argo-cd-back-end/dev-values.yaml > argocd-back-end-dev-deployment.yaml
helm template back-end-qa-deployment argo-cd-back-end/ -f argo-cd-back-end/qa-values.yaml > argocd-back-end-qa-deployment.yaml
helm template back-end-prod-deployment argo-cd-back-end/ -f argo-cd-back-end/prod-values.yaml > argocd-back-end-prod-deployment.yaml


helm install argocd-back-end-qa-realese argo-cd-back-end/ --values argo-cd-back-end/qa-values.yaml
helm install argocd-back-end-dev-realese argo-cd-back-end/ --values argo-cd-back-end/dev-values.yaml
helm install argocd-back-end-prod-realese argo-cd-back-end/ --values argo-cd-back-end/prod-values.yaml 

helm upgrade argocd-back-end-qa-realese argo-cd-back-end/ --values argo-cd-back-end/qa-values.yaml
helm upgrade argocd-back-end-dev-realese argo-cd-back-end/ --values argo-cd-back-end/dev-values.yaml
helm upgrade argocd-back-end-prod-realese argo-cd-back-end/ --values argo-cd-back-end/prod-values.yaml

helm uninstall argocd-back-end-qa-realese
helm uninstall argocd-back-end-dev-realese
helm uninstall argocd-back-end-prod-realese

helm template prod-deployment argocd/ -f argocd/prod-values.yaml | grep "# Source"

argocd app get backend-qa: Check application status.
argocd app diff <APP_NAME>: View sync differences.
argocd app resources <APP_NAME>: Check resource health.
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-application-controller --tail=50: View controller logs for errors.
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-repo-server --tail=50: View repo server logs.

# ARGO CD
sudo snap install helm --classic
kubectl create ns argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argo/argo-cd --namespace argocd
kubectl port-forward svc/argocd-server -n argocd 8081:80
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d


# argo cd cli
VERSION=$(curl -s https://api.github.com/repos/argoproj/argo-cd/releases/latest | grep tag_name | cut -d'"' -f 4)
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64
chmod +x argocd
sudo mv argocd /usr/local/bin/   

# 🚀 Install Argo Rollouts Dashboard UI:
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/dashboard-install.yaml

kubectl port-forward svc/argo-rollouts-dashboard -n argo-rollouts 3100:3100
kubectl get all -n argo-rollouts

kubectl argo rollouts dashboard