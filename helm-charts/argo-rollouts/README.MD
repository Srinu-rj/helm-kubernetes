=======================
ARGO CD
=======================
[--create-namespace ]
Install ArgoCD using Helm (for Kubernetes)::

sudo snap install helm --classic
kubectl create ns argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argo/argo-cd --namespace argocd
kubectl port-forward svc/argocd-server -n argocd 8081:80
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d

==============================================
🚀 Install Argo Rollouts Dashboard UI
==============================================
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts \
-f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
kubectl apply -n argo-rollouts \
-f https://github.com/argoproj/argo-rollouts/releases/latest/download/dashboard-install.yaml

kubectl port-forward svc/argo-rollouts-dashboard -n argo-rollouts 3100:3100

kubectl argo rollouts dashboard

==============================================
✅ Argo CD Canary Deployment (Using Argo Rollouts)::
==============================================

1️⃣ Canary Deployment (Most Used)::
strategy:
 canary:
   steps:
     - setWeight: 20
     - pause: { duration: 60s }
     - setWeight: 50
     - pause: { duration: 120s }
     - setWeight: 100

---
2️⃣ Blue-Green Deployment::

strategy:
 blueGreen:
   activeService: backend-active
   previewService: backend-preview
   autoPromotionEnabled: false

---
3️⃣ Rolling Update (Limited / Rare)

strategy:
 rollingUpdate:
   maxSurge: 1
   maxUnavailable: 0
