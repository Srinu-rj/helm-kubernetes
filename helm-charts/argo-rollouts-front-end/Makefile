CHART := argo-rollouts-front-end

.PHONY: \
	dev-template qa-template prod-template \
	dev-install qa-install prod-install \
	dev-upgrade qa-upgrade prod-upgrade \
	dev-uninstall qa-uninstall prod-uninstall

# TODO ==============Template ==============
dev-template:
	helm template argo-roll-out-front-end-dev-deployment $(CHART)/ -f $(CHART)/dev-values.yaml > argo-roll-out-dev-front-end-deployment.yaml
qa-template:
	helm template argo-roll-out-front-end-qa-deployment $(CHART)/ -f $(CHART)/qa-values.yaml > argo-roll-out-qa-front-end-deployment.yaml
prod-template:
	helm template argo-roll-out-front-end-prod-deployment $(CHART)/ -f $(CHART)/prod-values.yaml > argo-roll-out-prod-front-end-deployment.yaml

# TODO ==============Install ==============
dev-install:
	helm install argo-cd-rollout-dev-release-front-end $(CHART)/ --values $(CHART)/dev-values.yaml
qa-install:
	helm install argo-cd-rollout-qa-release-front-end $(CHART)/ --values $(CHART)/qa-values.yaml
prod-install:
	helm install argo-cd-rollout-prod-release-front-end $(CHART)/ --values $(CHART)/prod-values.yaml

# TODO ==============Upgrade ==============
dev-upgrade:
	helm upgrade argo-cd-rollout-dev-release-front-end $(CHART)/ --values $(CHART)/dev-values.yaml
qa-upgrade:
	helm upgrade argo-cd-rollout-qa-release-front-end $(CHART)/ --values $(CHART)/qa-values.yaml
prod-upgrade:
	helm upgrade argo-cd-rollout-prod-release-front-end $(CHART)/ --values $(CHART)/prod-values.yaml

# TODO ============== Uninstall ==============
dev-uninstall:
	helm uninstall argo-cd-rollout-dev-release-front-end
qa-uninstall:
	helm uninstall argo-cd-rollout-qa-release-front-end
prod-uninstall:
	helm uninstall argo-cd-rollout-prod-release-front-end


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