# BACK END
helm template qa-deployment backend/ -f backend/values-qa.yaml > back-end-deployment-qa.yaml
helm template dev-deployment backend/ -f backend/values-dev.yaml > back-end-deployment-dev.yaml
helm template future-deployment backend/ -f backend/values-future.yaml > back-end-deployment-future.yaml
helm template prod-deployment backend/ -f backend/values-prod.yaml > back-end-deployment-prod.yaml


helm install backend-qa-realese backend/ --values backend/values-qa.yaml
helm install backend-dev-realese backend/ --values backend/values-dev.yaml
helm install backend-future-realese backend/ --values backend/values-future.yaml
helm install backend-prod-realese backend/ --values backend/values-prod.yaml

# Upgrade a Helm chart with custom values [QA] [Dev] [Prod] [Future]
helm upgrade backend-qa-realese backend/ --values backend/values-qa.yaml
helm upgrade backend-dev-realese backend/ --values backend/values-dev.yaml  
helm upgrade backend-prod-realese backend/ --values backend/values-prod.yaml  
helm upgrade backend-future-realese backend/ --values backend/values-future.yaml  

helm uninstall backend-qa-realese
helm uninstall backend-dev-realese
helm uninstall backend-feture-realese
helm uninstall backend-prod-realese

kubectl get all -n qa-namespace
kubectl get all -n dev-namespace
kubectl get all -n future-namespace
kubectl get all -n prod-namespace
k get HTTPScaledObject -n back-end-qa-namespace


# DOMAIN
kubectl label nodes <node-name> <label-key>=<label-value>
kubectl label nodes worker-1 hardware=gpu   


affinity:
nodeAffinity:
requiredDuringSchedulingIgnoredDuringExecution:
nodeSelectorTerms:
- matchExpressions:
- key: hardware
operator: In
values:
- gpu


# HA PROXY
# Option A: Using Helm
helm repo add haproxytech https://haproxytech.github.io/helm-charts
helm repo update
helm install haproxy-kubernetes-ingress haproxytech/kubernetes-ingress --create-namespace --namespace haproxy-controller

# Option B: Using YAML Manifests [ best ]
kubectl apply -f https://raw.githubusercontent.com/haproxytech/kubernetes-ingress/refs/heads/master/deploy/haproxy-ingress.yaml
kubectl get pods --namespace haproxy-controller
kubectl get service --namespace haproxy-controller
curl http://172.16.51.8:30337/ -H 'Host: hello-world.example.com'

# Calico on Kubernetes for Red Hat Enterprise Linux (RHEL)::

helm repo add projectcalico https://docs.tigera.io/calico/charts
helm repo update

helm install calico projectcalico/tigera-operator \
--namespace tigera-operator \
--create-namespace \
--version v3.31.3

watch kubectl get pods -n tigera-operator
kubectl get pods -n calico-system

# METRICS SERVER
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml   
kubectl get pods -n kube-system | grep metrics-server


# KEDA HPA Autoscaling
# 🟢 Step 1: Install KEDA core (if not already)
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install keda kedacore/keda -n keda --create-namespace

helm install keda-http-addon kedacore/keda-add-ons-http -n keda
kubectl get crd | grep httpscaledobjects

Verify:
watch kubectl get pods -n keda
kubectl get crd | grep keda  http
kubectl get crd | grep http
kubectl get crd | grep "httpscaledobject"


# INSTALL KEDA :
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install keda kedacore/keda --namespace keda --create-namespace
kubectl get pods -n keda


kubectl apply -f https://github.com/kedacore/keda/releases/latest/download/keda.yaml
kubectl get pods -n keda
kubectl get crd | grep keda


helm upgrade keda kedacore/keda -n keda
# metrics-server → KEDA → HTTP add-on → apps



helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install keda kedacore/keda -n keda --create-namespace

helm install keda-http-addon kedacore/keda-add-ons-http -n keda
kubectl apply -f https://github.com/kedacore/http-add-on/releases/latest/download/http-add-on.crds.yaml

kubectl get crd | grep httpscaledobjects

helm install keda kedacore/keda --version 2.19.0 --namespace keda --create-namespace

kubectl get httpscaledobject
kubectl get svc -n keda | grep keda-add-ons-http-interceptor-proxy

# keda version 
kubectl get crd/scaledobjects.keda.sh -o yaml
watch kubectl get pods -n keda
kubectl get crd | grep keda
kubectl get crd | grep http
kubectl get crd | grep "httpscaledobject"

# UNINSTALL KEDA 
helm uninstall keda -n keda
kubectl delete $(kubectl get scaledobjects,scaledjobs -A -o jsonpath='{\"-n \"}{.items[*].metadata.namespace}{\" \"}{.items[*].kind}{\"/\"}{.items[*].metadata.name}{\"\\n\"}')
kubectl delete -f https://github.com/kedacore/keda/releases/download/v2.6.1/keda-2.6.1.yaml



# Manual Installation (from Git repo):
git clone https://github.com/kedacore/keda && cd keda
git checkout tags/v2.19.0
kubectl apply -f deploy/crds/


#🟢 Step 3: Confirm API version (important):
kubectl get crd httpscaledobjects.http.keda.sh -o yaml | grep version -A5


✅ METHOD 3: hey (Best Tool for KEDA HTTP)
sudo snap install hey

hey -n 10000 -c 300 -H "Host: myhost.com" http://localhost:1199/home
kubectl port-forward svc/backend-service 1199:80 -n back-end-qa-namespace


# CORE KUBERNETES:
kubectl get pods -n kube-system -l k8s-app=kube-dns   
kubectl describe pod -l k8s-app=kube-dns -n kube-system   
# Test DNS Resolution Inside the Cluster:
kubectl run -it --rm debug --image=busybox --restart=Never -- nslookup kubernetes.default   

# Test External DNS Resolution
kubectl run -it --rm debug --image=busybox --restart=Never -- nslookup google.com   

# Check CoreDNS Logs and Metrics :: View CoreDNS Logs
kubectl logs -n kube-system -l k8s-app=kube-dns --tail=100   

# Enable Query Logging (for debugging)
kubectl -n kube-system edit configmap coredns   
# Access CoreDNS Metrics
kubectl get pods -n kube-system -l k8s-app=kube-dns -o jsonpath='{.items[0].status.podIP}'   
curl http://<POD_IP>:9153/metrics   


sudo ss -tlpns
lscpu
cat /proc/cpuinfo
dmidecode -t 4
nproc
top  | htop

In Kubernetes, 1 CPU is equivalent to 1000 millicores (1000m)::

1000m = 1 CPU core
100m = 0.1 CPU core
500m = 0.5 CPU core 
