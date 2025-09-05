  argocd login $(kubectl get ingress -A| grep argocd | awk '{print $4}') --username admin --password $(argocd admin initial-password -n argocd | head -1) --insecure --skip-test-tls --grpc-web
   for app in frontend ; do
     argocd app create ${app} --repo https://github.com/pdevops78/helm-argocd-ingress.git --path chart --upsert --dest-server https://kubernetes.default.svc --dest-namespace default --insecure  --grpc-web --values values/${app}.yaml
   done

