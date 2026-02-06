# BACK END
helm template qa-deployment backend/ -f backend/values-qa.yaml > back-end-deployment-qa.yaml
helm template dev-deployment backend/ -f backend/values-dev.yaml > back-end-deployment-dev.yaml
helm template future-deployment backend/ -f backend/values-future.yaml > back-end-deployment-future.yaml
helm template prod-deployment backend/ -f backend/values-prod.yaml > back-end-deployment-prod.yaml


helm install backend-qa-realese backend/ --values backend/values-qa.yaml
helm install backend-dev-realese backend/ --values backend/values-dev.yaml
helm install backend-future-realese backend/ --values backend/values-future.yaml
helm install backend-prod-realese backend/ --values backend/values-prod.yaml

# Upgrade a Helm chart with custom values [QA] [Dev] [Prod] [Future]
helm upgrade backend-qa-realese backend/ --values backend/values-qa.yaml
helm upgrade backend-dev-realese backend/ --values backend/values-dev.yaml  
helm upgrade backend-prod-realese backend/ --values backend/values-prod.yaml  
helm upgrade backend-future-realese backend/ --values backend/values-future.yaml  

helm uninstall backend-qa-realese
helm uninstall backend-dev-realese
helm uninstall backend-feture-realese
helm uninstall backend-prod-realese

kubectl get all -n qa-namespace
kubectl get all -n dev-namespace
kubectl get all -n future-namespace
kubectl get all -n prod-namespace

