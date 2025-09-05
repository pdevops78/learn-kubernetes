helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# service for nlb
helm upgrade --install ngx-ingres ingress-nginx/ingress-nginx -f ingress.yaml
kubectl create namespace  argocd
kubectl apply -f argocd-ingress-dev.yaml -n argocd


