CHART := argo-cd-front-end

.PHONY: \
	dev-template qa-template prod-template \
	dev-install qa-install prod-install \
	dev-upgrade qa-upgrade prod-upgrade \
	dev-uninstall qa-uninstall prod-uninstall


# TODO ============= Template =============
dev-template:
	helm template front-end-dev-deployment $(CHART)/ -f $(CHART)/dev-values.yaml > argocd-front-end-dev-deployment.yaml
qa-template:
	helm template front-end-qa-deployment $(CHART)/ -f $(CHART)/qa-values.yaml > argocd-front-end-qa-deployment.yaml
prod-template:
	helm template front-end-prod-deployment $(CHART)/ -f $(CHART)/prod-values.yaml > argocd-front-end-prod-deployment.yaml


#TODO =============Install =============
dev-install:
	helm install argocd-front-end-dev-release $(CHART)/ --values $(CHART)/dev-values.yaml
qa-install:
	helm install argocd-front-end-qa-release $(CHART)/ --values $(CHART)/qa-values.yaml
prod-install:
	helm install argocd-front-end-prod-release $(CHART)/ --values $(CHART)/prod-values.yaml


#TODO  ===========Upgrade=============
dev-upgrade:
	helm upgrade argocd-front-end-dev-release $(CHART)/ --values $(CHART)/dev-values.yaml
qa-upgrade:
	helm upgrade argocd-front-end-qa-release $(CHART)/ --values $(CHART)/qa-values.yaml
prod-upgrade:
	helm upgrade argocd-front-end-prod-release $(CHART)/ --values $(CHART)/prod-values.yaml


# TODO ============= Uninstall =============
dev-uninstall:
	helm uninstall argocd-front-end-dev-release
qa-uninstall:
	helm uninstall argocd-front-end-qa-release
prod-uninstall:
	helm uninstall argocd-front-end-prod-release

## Template
#make dev-template qa-template prod-template future-template
#
## Install
#make dev-install qa-install prod-install future-install
#
## Upgrade
#make dev-upgrade qa-upgrade prod-upgrade future-upgrade
#
## Uninstall
#make dev-uninstall qa-uninstall prod-uninstall future-uninstall
#
## Status
#make dev-status qa-status prod-status future-status