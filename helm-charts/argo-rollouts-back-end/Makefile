CHART := argo-rollouts-back-end

.PHONY: \
	dev-template qa-template prod-template \
	dev-install qa-install prod-install \
	dev-upgrade qa-upgrade prod-upgrade \
	dev-uninstall qa-uninstall prod-uninstall

# TODO ================Template================
dev-template:
	helm template argo-roll-out-back-end-dev-deployment $(CHART)/ -f $(CHART)/dev-values.yaml > argo-roll-out-dev-back-end-deployment.yaml
qa-template:
	helm template argo-roll-out-back-end-qa-deployment $(CHART)/ -f $(CHART)/qa-values.yaml > argo-roll-out-qa-back-end-deployment.yaml
prod-template:
	helm template argo-roll-out-back-end-prod-deployment $(CHART)/ -f $(CHART)/prod-values.yaml > argo-roll-out-prod-back-end-deployment.yaml

# TODO ================Install================
dev-install:
	helm install argo-cd-rollout-dev-release-back-end $(CHART)/ --values $(CHART)/dev-values.yaml
qa-install:
	helm install argo-cd-rollout-qa-release-back-end $(CHART)/ --values $(CHART)/qa-values.yaml
prod-install:
	helm install argo-cd-rollout-prod-release-back-end $(CHART)/ --values $(CHART)/prod-values.yaml

# TODO ================Upgrade  ================
dev-upgrade:
	helm upgrade argo-cd-rollout-dev-release-back-end $(CHART)/ --values $(CHART)/dev-values.yaml
qa-upgrade:
	helm upgrade argo-cd-rollout-qa-release-back-end $(CHART)/ --values $(CHART)/qa-values.yaml
prod-upgrade:
	helm upgrade argo-cd-rollout-prod-release-back-end $(CHART)/ --values $(CHART)/prod-values.yaml

# TODO ================ UninstallT ================
dev-uninstall:
	helm uninstall argo-cd-rollout-dev-release-back-end
qa-uninstall:
	helm uninstall argo-cd-rollout-qa-release-back-end
prod-uninstall:
	helm uninstall argo-cd-rollout-prod-release-back-end



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