CHART := front-end

.PHONY: \
	dev-template qa-template prod-template future-template \
	dev-install qa-install prod-install future-install \
	dev-upgrade qa-upgrade prod-upgrade future-upgrade \
	dev-uninstall qa-uninstall prod-uninstall future-uninstall \
	dev-status qa-status prod-status future-status

# ── Template ──────────────────────────────────────────────────────────────────
dev-template:
	helm template frontend-dev-deployment $(CHART)/ -f $(CHART)/values-dev.yaml > front-end-deployment-dev.yaml
qa-template:
	helm template frontend-qa-deployment $(CHART)/ -f $(CHART)/values-qa.yaml > front-end-deployment-qa.yaml
prod-template:
	helm template frontend-prod-deployment $(CHART)/ -f $(CHART)/values-prod.yaml > front-end-deployment-prod.yaml
future-template:
	helm template frontend-future-deployment $(CHART)/ -f $(CHART)/values-future.yaml > front-end-deployment-future.yaml

# ── Install ───────────────────────────────────────────────────────────────────
dev-install:
	helm install frontend-dev-release $(CHART)/ --values $(CHART)/values-dev.yaml
qa-install:
	helm install frontend-qa-release $(CHART)/ --values $(CHART)/values-qa.yaml
prod-install:
	helm install frontend-prod-release $(CHART)/ --values $(CHART)/values-prod.yaml
future-install:
	helm install frontend-future-release $(CHART)/ --values $(CHART)/values-future.yaml

# ── Upgrade ───────────────────────────────────────────────────────────────────
dev-upgrade:
	helm upgrade frontend-dev-release $(CHART)/ --values $(CHART)/values-dev.yaml
qa-upgrade:
	helm upgrade frontend-qa-release $(CHART)/ --values $(CHART)/values-qa.yaml
prod-upgrade:
	helm upgrade frontend-prod-release $(CHART)/ --values $(CHART)/values-prod.yaml
future-upgrade:
	helm upgrade frontend-future-release $(CHART)/ --values $(CHART)/values-future.yaml


# ── Uninstall ─────────────────────────────────────────────────────────────────
dev-uninstall:
	helm uninstall frontend-dev-release
qa-uninstall:
	helm uninstall frontend-qa-release
prod-uninstall:
	helm uninstall frontend-prod-release
future-uninstall:
	helm uninstall frontend-future-release


# ── Status ────────────────────────────────────────────────────────────────────
dev-status:
	kubectl get all -n dev-namespace
qa-status:
	kubectl get all -n qa-namespace
prod-status:
	kubectl get all -n prod-namespace
future-status:
	kubectl get all -n future-namespace
