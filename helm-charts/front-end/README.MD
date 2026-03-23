# FRONT END TEMPLATE
helm template frontend-dev-deployment front-end/ -f front-end/values-dev.yaml > front-end-deployment-dev.yaml
helm template frontend-qa-deployment front-end/ -f front-end/values-qa.yaml > front-end-deployment-qa.yaml
helm template frontend-prod-deployment front-end/ -f front-end/values-prod.yaml > front-end-deployment-prod.yaml

helm test frontend-qa-release
helm test frontend-dev-release
helm test frontend-prod-release

# FRONT END DEPLOYMENTS
helm install frontend-qa-release front-end/ --values front-end/values-qa.yaml --timeout 2m && helm test frontend-qa-release --logs
helm install frontend-dev-release front-end/ --values front-end/values-dev.yaml --timeout 5m && helm test frontend-dev-release --logs
helm install frontend-prod-release front-end/ --values front-end/values-prod.yaml --timeout 5m && helm test frontend-prod-release --logs
helm install frontend-future-release front-end/ --values front-end/values-future.yaml --timeout 5m && helm test frontend-future-release --logs

# Upgrade a Helm chart with custom values [QA] [Dev] [Prod] [Future]
helm upgrade frontend-qa-release front-end/ --values front-end/values-qa.yaml --timeout 5m && helm test frontend-qa-release --logs
helm upgrade frontend-dev-release front-end/ --values front-end/values-dev.yaml  --timeout 5m && helm test frontend-dev-release --logs
helm upgrade frontend-prod-release front-end/ --values front-end/values-prod.yaml  --timeout 5m && helm test frontend-prod-release --logs
helm upgrade frontend-future-release front-end/ --values front-end/values-future.yaml --timeout 5m && helm test frontend-future-release --logs

helm lint ./front-end
helm lint ./backend --strict

watch kubectl get all -n front-end-qa-namespace
watch kubectl get all -n front-end-dev-namespace
watch kubectl get all -n front-end-prod-namespace
watch kubectl get all -n front-end-future-namespace

helm uninstall frontend-qa-release
helm uninstall frontend-dev-release
helm uninstall frontend-prod-release
helm uninstall frontend-future-release

k port-forward -n front-qa-namespace svc/frontend-service 3000:80