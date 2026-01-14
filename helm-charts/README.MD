 # Create and delete [ Helm chart ]
 helm create backend
 helm install backend-rle backend
 helm upgrade backend-rle backend
 helm uninstall backend-rle
 helm install backend-rle backend/ --values backend/values-qa.yaml
 helm upgrade backend-rle backend/ --values backend/values-qa.yaml
 
 # Manifest and Template 
 helm get manifest backend-rle
 helm get manifest backend-rle > backend-qa-manifest.yaml
 # Template generation for different environments [Important]*
 helm template dev-deployment backend/ -f backend/values-dev.yaml > dev-deployment.yaml
 helm template qa-deployment backend/ -f backend/values-qa.yaml > qa-deployment.yaml
 helm template future-deployment backend/ -f backend/values-future.yaml > future-deployment.yaml
 helm template prod-deployment backend/ -f backend/values-prod.yaml > prod-deployment.yaml

 # Install a Helm chart with custom values [QA] [Dev] [Prod] [Future]
 helm install backend-rle backend/ --values backend/values-qa.yaml -n qa --create-namespace
 helm upgrade backend-rle backend/ --values backend/values-dev.yaml -n qa --create-namespace
 helm install backend-rle backend/ --values backend/values-prod.yaml -n database-dev
 helm upgrade backend-rle backend/ --values backend/values-future.yaml -n database-dev

 # List all Helm releases
 helm list -a 

 # Install a Helm chart with custom values [Deployment]
 helm install <chart-name> <chart-location> -f values-nginx.yml 
 helm uninstall chart-name

 # Generate templates for different environments
 helm template backend-rle ./backend/values-dev.yaml ./backend/ -n qa > dev-template.yaml
 helm template qa-template ./backend/values-qa.yaml ./backend/ -n qa > qa-template.yaml
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
#No Need to specify Namespace while Deleting and Deploying Helm Charts
![img_4.png](img_4.png)

# Kubernetes Objects:
![img_5.png](img_5.png)


[//]: # (How to Remove Finalizers)
kubectl get namespace backend -o json > ns.json
"finalizers": []
kubectl replace --raw "/api/v1/namespaces/backend/finalize" -f ns.json

[//]: # (Example: Remove finalizer from Pod / PVC)
kubectl patch pvc my-pvc -p '{"metadata":{"finalizers":[]}}' --type=merge

# KEDA HPA Autoscaling
# 🟢 Step 1: Install KEDA core (if not already)
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install keda kedacore/keda -n keda --create-namespace

Verify:
kubectl get pods -n keda
kubectl get crd | grep keda
kubectl get crd | grep http


#🟢 Step 2: Install KEDA HTTP Add-on (THIS IS REQUIRED)
helm install keda-http-addon kedacore/keda-add-ons-http -n keda
kubectl get crd | grep httpscaledobjects

#🟢 Step 3: Confirm API version (important):
kubectl get crd httpscaledobjects.http.keda.sh -o yaml | grep version -A5

🔹 4️⃣ Generate Load
✅ METHOD 1: curl (Simple Test)

for i in {1..500}; do
   curl -H "Host: myhost.com" http://localhost:1199 &
done

✅ METHOD 2: Apache Bench (Recommended)
sudo apt install apache2-utils

ab -n 5000 -c 200 -H "Host: myhost.com" http://localhost:8080/

-n → total requests
-c → concurrent requests


✅ METHOD 3: hey (Best Tool for KEDA HTTP)
sudo snap install hey

hey -n 10000 -c 300 -H "Host: myhost.com" http://localhost:8080


🔹 5️⃣ Watch Autoscaling Live
kubectl get pods -n qa -w
kubectl get httpscaledobject -n qa -w
