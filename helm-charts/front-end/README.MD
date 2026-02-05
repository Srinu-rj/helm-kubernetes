# FRONT END TEMPLATE
helm template frontend-dev-deployment front-end/ -f front-end/values-dev.yaml > front-end-deployment-dev.yaml
helm template frontend-qa-deployment front-end/ -f front-end/values-qa.yaml > front-end-deployment-qa.yaml
helm template frontend-prod-deployment front-end/ -f front-end/values-prod.yaml > front-end-deployment-prod.yaml

# FRONT END DEPLOYMENTS
helm install frontend-qa-realese front-end/ --values front-end/values-qa.yaml
helm install frontend-dev-realese front-end/ --values front-end/values-dev.yaml
helm install frontend-prod-realese front-end/ --values front-end/values-prod.yaml
helm install frontend-future-realese front-end/ --values front-end/values-future.yaml # [optional ]

# Upgrade a Helm chart with custom values [QA] [Dev] [Prod] [Future]
helm upgrade frontend-qa-realese front-end/ --values front-end/values-qa.yaml
helm upgrade frontend-dev-realese front-end/ --values front-end/values-dev.yaml  
helm upgrade frontend-prod-realese front-end/ --values front-end/values-prod.yaml  
helm upgrade frontend-future-realese front-end/ --values front-end/values-future.yaml
 
k port-forward -n front-qa-namespace svc/frontend-service 3000:80