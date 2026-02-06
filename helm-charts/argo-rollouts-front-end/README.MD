helm template argo-roll-out-front-end-dev-deployment argo-rollouts-front-end/ -f argo-rollouts-front-end/dev-values.yaml > argo-roll-out-dev-front-end-deployment.yaml
helm template argo-roll-out-front-end-qa-deployment argo-rollouts-front-end/ -f argo-rollouts-front-end/qa-values.yaml > argo-roll-out-qa-front-end-deployment.yaml
helm template argo-roll-out-front-end-prod-deployment argo-rollouts-front-end/ -f argo-rollouts-front-end/prod-values.yaml > argo-roll-out-prod-front-end-deployment.yaml


helm install argo-cd-rollout-dev-realese-front-end argo-rollouts-front-end/ --values argo-rollouts-front-end/dev-values.yaml
helm install argo-cd-rollout-qa-realese-front-end  argo-rollouts-front-end/ --values argo-rollouts-front-end/qa-values.yaml
helm install argo-cd-rollout-prod-realese-front-end argo-rollouts-front-end/ --values argo-rollouts-front-end/prod-values.yaml

helm upgrade argo-cd-rollout-dev-realese-front-end argo-rollouts-front-end/ --values argo-rollouts-front-end/dev-values.yaml
helm upgrade argo-cd-rollout-qa-realese-front-end argo-rollouts-front-end/ --values argo-rollouts-front-end/qa-values.yaml
helm upgrade argo-cd-rollout-prod-realese-front-end argo-rollouts-front-end/ --values argo-rollouts-front-end/prod-values.yaml

helm uninstall argo-cd-rollout-qa-realese-front-end
helm uninstall argo-cd-rollout-dev-realese-front-end
helm uninstall argo-cd-rollout-prod-realese-front-end

helm template prod-deployment argocd/ -f argocd/prod-values.yaml | grep "# Source"




=======================
ARGO CD
=======================
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
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/dashboard-install.yaml
kubectl port-forward svc/argo-rollouts-dashboard -n argo-rollouts 3100:3100
kubectl argo rollouts dashboard

==============================================
✅ Argo CD Canary Deployment (Using Argo Rollouts)::
==============================================
# 
1️⃣ Canary Deployment (Most Used)::
strategy:
 canary:
   steps:
     - setWeight: 20
     - pause: { duration: 60s }
    #TODO  -> “Before moving to the next canary step, run a health check based on metrics.”✅ Inside Canary Steps
     - analysis: 
         templates:
           - templateName: error-rate     
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
---
# 👉 Helm ArgoCd Rollout analysis template
# 1️⃣ Single AnalysisTemplate (Most Common):: ✔ Simple validation (latency, error rate, availability)
- analysis:
  templates:
  - templateName: latency

# 2️⃣ Multiple AnalysisTemplates (Parallel Analysis):==> ✔ Validate multiple metrics at once
- analysis:
  templates:
  - templateName: error-rate
  - templateName: latency
  - templateName: availability

# 3️⃣ AnalysisTemplate with Arguments (Dynamic Values):: --> ✔ Same template, different thresholds per app/env
- analysis:
    templates:
      - templateName: latency
        arguments:
          - name: maxLatency
            value: "400"

# 5️⃣ ClusterAnalysisTemplate (Cluster-wide):: --> 
- analysis:
    templates:
      - templateName: global-latency
        clusterScope: true

