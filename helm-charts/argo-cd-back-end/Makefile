CHART := argo-cd-back-end

.PHONY: \
	dev-template qa-template prod-template \
	dev-install qa-install prod-install \
	dev-upgrade qa-upgrade prod-upgrade \
	dev-uninstall qa-uninstall prod-uninstall


# TODO ================== Template ==================
dev-template:
	helm template back-end-dev-deployment $(CHART)/ -f $(CHART)/dev-values.yaml > argocd-back-end-dev-deployment.yaml
qa-template:
	helm template back-end-qa-deployment $(CHART)/ -f $(CHART)/qa-values.yaml > argocd-back-end-qa-deployment.yaml
prod-template:
	helm template back-end-prod-deployment $(CHART)/ -f $(CHART)/prod-values.yaml > argocd-back-end-prod-deployment.yaml


# TODO ================== Install ==================
dev-install:
	helm install argocd-back-end-dev-release $(CHART)/ --values $(CHART)/dev-values.yaml
qa-install:
	helm install argocd-back-end-qa-release $(CHART)/ --values $(CHART)/qa-values.yaml
prod-install:
	helm install argocd-back-end-prod-release $(CHART)/ --values $(CHART)/prod-values.yaml


# TODO ================== Upgrade ==================
dev-upgrade:
	helm upgrade argocd-back-end-dev-release $(CHART)/ --values $(CHART)/dev-values.yaml
qa-upgrade:
	helm upgrade argocd-back-end-qa-release $(CHART)/ --values $(CHART)/qa-values.yaml
prod-upgrade:
	helm upgrade argocd-back-end-prod-release $(CHART)/ --values $(CHART)/prod-values.yaml


# TODO ==================Uninstall==================
dev-uninstall:
	helm uninstall argocd-back-end-dev-release
qa-uninstall:
	helm uninstall argocd-back-end-qa-release
prod-uninstall:
	helm uninstall argocd-back-end-prod-release

## Template
#make dev-template qa-template prod-template
#
## Install
#make dev-install qa-install prod-install
#
## Upgrade
#make dev-upgrade qa-upgrade prod-upgrade
#
## Uninstall
#make dev-uninstall qa-uninstall prod-uninstall