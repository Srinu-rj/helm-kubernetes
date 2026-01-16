 # Create and delete [ Helm chart ]
 helm create backend
 helm install backend-rle backend
 helm upgrade backend-rle backend
 helm uninstall backend-rle
 k get pods --all-namespaces

 # Manifest and Template 
 helm get manifest backend-rle
 helm get manifest backend-rle > backend-qa-manifest.yaml

 # Template generation for different environments [Important]*
![img_6.png](img_6.png) [QA] [Dev] [Prod] [Future]
 helm template dev-deployment backend/ -f backend/values-dev.yaml > deployment-dev.yaml
 helm template qa-deployment backend/ -f backend/values-qa.yaml > deployment-qa.yaml
 helm template future-deployment backend/ -f backend/values-future.yaml > deployment-future.yaml
 helm template prod-deployment backend/ -f backend/values-prod.yaml > deployment-prod.yaml

 # Install a Helm chart with custom values [QA] [Dev] [Prod] [Future]
 # QA Environment
 ![img_10.png](img_10.png)
 # Dev Environment
 # Prod Environment
 helm install backend-qa-realese backend/ --values backend/values-qa.yaml 
 helm install backend-dev-realese backend/ --values backend/values-dev.yaml 
 helm install backend-prod-realese backend/ --values backend/values-prod.yaml 
 helm install backend-future-realese backend/ --values backend/values-future.yaml 

 # Upgrade a Helm chart with custom values [QA] [Dev] [Prod] [Future]
 helm upgrade backend-qa-realese backend/ --values backend/values-qa.yaml 
 helm upgrade backend-dev-realese backend/ --values backend/values-dev.yaml  
 helm upgrade backend-prod-realese backend/ --values backend/values-prod.yaml  
 helm upgrade backend-future-realese backend/ --values backend/values-future.yaml  

 # Verify the deployments
 kubectl get all -n qa-namespace
 kubectl get all -n dev-namespace
 kubectl get all -n prod-namespace
 kubectl get all -n future-namespace
 
 # Uninstall a Helm chart [QA] [Dev] [Prod] [Future]
 helm uninstall backend-qa-realese
 helm uninstall backend-dev-realese
 helm uninstall backend-feture-realese
 helm uninstall backend-prod-realese

 kubectl delete namespace qa-namespace
 
 # kubernetes objects[ KEDA | svc | ingress | hpa | pvc | pv | cm | secret ]:
 kubectl explain httpscaledobject.spec
 kubectl explain httpscaledobject.spec.scaleTargetRef
 kubectl get crd | grep http



 # List all Helm releases
 helm list -a
 helm uninstall backend-dev-realese backend-future-realese backend-prod-realese backend-qa-realese

 # Install a Helm chart with custom values [Deployment]
 helm install <chart-name> <chart-location> -f values-nginx.yml 
 helm uninstall chart-name


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
# Before ResourceQuotas [in Qa Namespace]
![img_7.png](img_7.png)
# After ResourceQuotas [in Qa Namespace]
![img_8.png](img_8.png)

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


# Helm kustomization:
Install kustomize:- curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash 
![img_9.png](img_9.png)