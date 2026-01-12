 # Create a new Helm chart
 helm create backend
 helm install backend-rle backend
 helm upgrade backend-rle backend
 helm uninstall backend-rle
 helm install backend-rle backend/ --values backend/values-qa.yaml -n database-qa --create-namespace
 helm install backend-rle backend/ --values backend/values-qa.yaml -n database-dev
 helm upgrade backend-rle backend/ --values backend/values-dev.yaml -n database-dev

 # List all Helm releases
 helm list -a 

 # Install a Helm chart with custom values [Deployment]
 helm install <chart-name> <chart-location> -f values-nginx.yml 
 helm uninstall chart-name

 # Generate templates for different environments
 helm template dev-template ./backend/values-dev.yaml ./backend/ -n database-api > dev-template.yaml
 helm template qa-template ./backend/values-qa.yaml ./backend/ -n database > qa-template.yaml
 helm template future-template ./backend/values-feture.yaml ./backend/ -n database > future-template.yaml
 helm template prod-template ./backend/values-prod.yaml ./backend/ -n database > prod-template.yaml

helm template dev-template ./backend -f ./backend/values-qa.yaml -n database-api

✅ List all releases (current namespace)
helm list

✅ List releases in a specific namespace
helm list -n database-api

✅ List releases in ALL namespaces
helm list -A

✅ Get details of a release
helm status dev-template -n database-api

✅ Get release history (revisions)
helm history dev-template -n database-api

📄 2️⃣ How to Get Helm Templates (Rendered YAML)

✅ Render all templates (dry run)
helm template dev-template ./backend -n database-api

✅ Render with values file
helm template dev-template ./backend -f values-qa.yaml -n database-api

✅ Debug rendered templates
helm template dev-template ./backend -f values-qa.yaml --debug

✅ Render only one template file
helm template dev-template ./backend -f values-qa.yaml --show-only templates/deployment.yaml

🔍 3️⃣ How to See Templates of an Installed Release
✅ Get rendered manifests from cluster
helm get manifest dev-template -n database-api

✅ Get values used by release
helm get values dev-template -n database-api

✅ Get full release info
helm get all dev-template -n database-api

# HELM DEPLOYMENT IMAGES
![img.png](img.png)
![img_1.png](img_1.png)
![img_2.png](img_2.png)
![img_3.png](img_3.png)



[//]: # (How to Remove Finalizers)
kubectl get namespace backend -o json > ns.json
"finalizers": []
kubectl replace --raw "/api/v1/namespaces/backend/finalize" -f ns.json

[//]: # (Example: Remove finalizer from Pod / PVC)
kubectl patch pvc my-pvc -p '{"metadata":{"finalizers":[]}}' --type=merge

