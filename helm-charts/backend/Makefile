CHART := .

.PHONY: template install upgrade uninstall status

qa-template:
	helm template qa-deployment      $(CHART)/ -f $(CHART)/values-qa.yaml     > back-end-deployment-qa.yaml
dev-template:
	helm template dev-deployment     $(CHART)/ -f $(CHART)/values-dev.yaml    > back-end-deployment-dev.yaml
future-template:
	helm template future-deployment  $(CHART)/ -f $(CHART)/values-future.yaml > back-end-deployment-future.yaml
prod-template:
	helm template prod-deployment    $(CHART)/ -f $(CHART)/values-prod.yaml   > back-end-deployment-prod.yaml

qa-install:
	helm install backend-qa-release      $(CHART)/ --values $(CHART)/values-qa.yaml
dev-install:
	helm install backend-dev-release     $(CHART)/ --values $(CHART)/values-dev.yaml
future-install:
	helm install backend-future-release  $(CHART)/ --values $(CHART)/values-future.yaml
prod-install:
	helm install backend-prod-release    $(CHART)/ --values $(CHART)/values-prod.yaml

qa-upgrade:
	helm upgrade backend-qa-release      $(CHART)/ --values $(CHART)/values-qa.yaml
dev-upgrade:
	helm upgrade backend-dev-release     $(CHART)/ --values $(CHART)/values-dev.yaml
future-upgrade:
	helm upgrade backend-future-release  $(CHART)/ --values $(CHART)/values-future.yaml
prod-upgrade:
	helm upgrade backend-prod-release    $(CHART)/ --values $(CHART)/values-prod.yaml

qa-uninstall:
	helm uninstall backend-qa-release
dev-uninstall:
	helm uninstall backend-dev-release
future-uninstall:
	helm uninstall backend-future-release
prod-uninstall:
	helm uninstall backend-prod-release

qa-status:
	kubectl get all -n qa-namespace
dev-status:
	kubectl get all -n dev-namespace
future-status:
	kubectl get all -n future-namespace
prod-status:
	kubectl get all -n prod-namespace