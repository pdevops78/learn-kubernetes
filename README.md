# learn-kubernetes

Task	Component Responsible
Create Pod: 	User / Controller (kubectl, Deployment, etc.)
Validate and store Pod: 	API server → etcd
Assign Pod to a Node: 	Kube-scheduler
Store updated Pod with Node info: 	API server → etcd
Watch and run Pod:	Kubelet (on assigned Node)
Report Pod status:	Kubelet → API server → etcd

KMS and autoscaling 
create a pod
configMap and Secret, how to access configMap and secret in pod?
How to retrieve the data from vault


1. export vault_address=https://vault-internal.pdevops78.online:8200
2. export VAULT_TOKEN=
3. 
vault login vault_token
vault kv get common/common
vault tls_skip_verify kv get -mount=secret common
vault kv get common/common | sed -n -e '/=Data=/,$p' | grep -Ev '= Data =|^key|^---'| awk '{print "export "$1"="$2}' 

run manually:
==============
* docker build .
* docker images
* docker run -it --entrypoint bash container-id: go inside container
* docker run -e VAULT_ADDR="" -e VAULT_TOKEN="" -e SECRET_NAME="" -e VAULT_SKIP_VERIFY=true "container-id"
* to create a token in k8
  kubectl create secret generic vault-token --from-literal=token=my-secret-value
* kubectl get secret vault-token -o yaml
or we have to write in yaml file

schema:
=======
kubectl get pods -o wide



docker basics:
==============
docker run nginx, run in our terminal
docker run docker.io/nginx
to run in detached mode : docker run -d docker.io/nginx
docker ps
docker inspect "container-id"
docker run -P -d docker.io/nginx , to expose the app outside use -p
docker ps ; here we can able to see the ports
to customize port: docker run -p 1000:80 docker.io/nginx , here 1000 is a host side and 80 is a container side port

basic docker:
==============
FROM     nginx
COPY     index.html /usr/share/nginx/html/index.html

steps:
======
1. docker build .
2. docker run -d "image-id"
3. docker run -P -d "contaienr id"
4. docker ps 
5. expose app based on port
6. docker inspect "container-id" : to know container info. 
7. search one ip : curl 10.0....
8. docker exec -it "container-id" bash
9. caddy file path: cd /etc/caddy ; ls ; cat Caddyfile
10. docker run docker.io/redhat/ubi9 env, to get env vars
11. docker run -e url=google.com docker.io/redhat/ubi9 env
12. add newrelic: latest in package.json, once install through package.json no need to install as a package manager in ansible
13. docker run -it docker.io/node bash
14. 



argocd:
=======
kubectl get svc
kubectl get svc -n argocd
kubectl edit svc -n argocd : change servicetype as LoadBalancer instead of ClusterIP


argocd:
-------
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get svc 
kubectl edit svc argocd-server (or)
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl get svc argocd-server -n argocd -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'
to retrieve password simply:
============================
argocd admin initial-password -n argocd
here username is "admin"
to create argocd application:
argocd app create guestbook --repo https://github.com/pdevops78/learn-kubernetes.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default.svc

argocd app create backend --repo https://github.com/devps23/eks-helm-argocd.git --path expense-chart/chart --upsert --dest-server https://kubernetes.default.svc --dest-namespace default.svc --grpc-web --values values/backend.yaml
argocd app sync guestbook

argocd app
argocd app sync --help
how to sync automatically in argocd?
argocd app set frontend --parameter imageVersion=v3
argocd app sync frontend
kubectl get configmap -A
kubectl get configmap -n kube-system aws-auth -o yaml


https://www.youtube.com/watch?v=bu0M2y2g1m8: OIDC



replicaset:
===========
kubectl get pods
kubectl get pod frontend-00 -o yaml
kubectl get pod frontend-00 -o yaml | grep image
kubectl get replicaset
kubectl get replicaset frontend -o yaml


cluster OIDC: https://oidc.eks.us-east-1.amazonaws.com/id/87DA3921190990DCFF161C615A70C9C5
Cluster IAM role ARN
arn:aws:iam::041445559784:role/AmazonEKSAutoClusterRole
Cluster ARN
arn:aws:eks:us-east-1:041445559784:cluster/eks
API server endpoint
https://87DA3921190990DCFF161C615A70C9C5.sk1.us-east-1.eks.amazonaws.com




for prometheus:
================
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm search repo prometheus-community
helm install prometheus prometheus-community/kube-prometheus-stack

NGINX ingress:
==============
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm show values ingress-nginx/ingress-nginx > custom-values.yaml
helm upgrade --install nginx-ingress ingress-nginx/ingress-nginx -f custom-values.yaml
// add  custom-values.yaml (about LoadBalancer NLB)





